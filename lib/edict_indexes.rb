require 'active_support/core_ext/hash'
require './lib/edict_parser'

class EdictIndexes < HashWithIndifferentAccess

  LINES_UNTIL_FLUSH = 30000

  def initialize input_filename
    @input_filename = input_filename
  end

  def destructive_rebuild_db! *types
    destroy_all!
    import(*types)
  end

  private

  def destroy_all!
    redis.flushdb
  end


  def import *types
    @start_time = Time.now
    puts "Building edict indexes and entries"

    redis.multi

    tokens_for(*types).each do |line_number, type, values|
      values.each do |v|
        redis.sadd "#{type}:#{v}", line_number

        v.strip!

        (1.. v.length).each do |l|
          prefix = v[0...l]
          redis.zadd('auto_complete', 0, prefix)
        end

        prefix = v + "*"
        redis.zadd('auto_complete', 0, prefix)
      end

      redis.hmset "entry:#{line_number}", type, values

      if (line_number % LINES_UNTIL_FLUSH) == 0
        redis.exec
        redis.multi
      end
    end
    puts "Final redis.exec"
    redis.exec
  end

  def tokens_for *types
    key_count = 0
    @line_count = lines.count
    tokens = []

    lines.each_with_index do |l, index|
      line_number = index + 1
      parser = parser(l)

      types.each do |type|
        values = Array(parser.send(type))

        if values.any?
          log(type, values, line_number, key_count)

          key_count +=1
          tokens << [line_number, type, values]
        end
      end
    end

    tokens
  end

  def log type, value, line_number, key_count
    should_notify = type == :kanji && (line_number % LINES_UNTIL_FLUSH) == 0
    if should_notify
      say_time
      puts "#{key_count} keys added"
      percent = 100.0 * line_number.to_f / @line_count.to_f
      puts "Adding entry ##{line_number}/#{@line_count} - #{percent}%, #{type}:#{value}"
    end
  end

  def puts s
    return nil unless ENV["debug"]

    Kernel.puts s
  end

  def say_time
    diff = Time.now - @start_time
    puts "Time since start: #{diff}"
  end

  def lines
    return @lines if @lines
    @lines = convert_to_utf_8

    @lines = @lines[1..-1] if @lines[0][0..5]=="/EDICT" #Skip first line if standard comment

    @lines
  end

  def parser line
    EdictParser.new line
  end

  def convert_to_utf_8
    ['euc-jp','utf-8'].each do |encoding|
      begin
        return File.readlines(@input_filename) if encoding == 'utf-8'

        ec = Encoding::Converter.new(encoding, 'utf-8')
        return ec.convert(File.read @input_filename).split("\n")
      rescue Encoding::InvalidByteSequenceError
        next
      end
    end
  end
end
