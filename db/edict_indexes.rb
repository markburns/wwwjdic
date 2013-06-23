class EdictIndexes < HashWithIndifferentAccess
  include RedisHelpers
  LINES_UNTIL_FLUSH = 10_000

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

    tokens_for(*types) do |line_number, type, values|
    redis.pipelined do
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

      redis.hmset "entry:#{line_number}", type, values.to_json
    end
    end
  end

  def tokens_for *types
    key_count = 0

    @line_count = read_lines.count

    lines = read_lines.lazy.with_index
    lines.each do |l, index|
      line_number = index + 1
      parser = parser(l)

      types.each do |type|
        values = Array(parser.send(type))

        if values.any?
          log(type, values, line_number, key_count)

          key_count +=1
          yield [line_number, type, values]
        end
      end
    end
  end

   
  def log type, value, line_number, key_count
    should_notify = type == :kanji && (line_number % LINES_UNTIL_FLUSH) == 0
    if should_notify
      percent = 100.0 * line_number.to_f / @line_count.to_f
      say_time percent
      puts "#{key_count} keys added"
      puts "Adding entry ##{line_number}/#{@line_count} - #{percent}%, #{type}:#{value}"
    end
  end

  def puts s
    return nil unless ENV["debug"]

    Kernel.puts s
  end

  def say_time percentage
    seconds = Time.now - @start_time
    puts "_" * 80
    puts "Time since start: #{formatted_eta seconds}s"
    percentage_per_second = percentage / seconds
    remaining_percent = (100 - percentage)

    remaining_seconds = remaining_percent / percentage_per_second
    eta = Time.now + remaining_seconds

    puts "ETA: #{eta}\n     #{formatted_eta remaining_seconds}"
  end

  def formatted_eta seconds
    return "#{seconds}s" if seconds < 60

    "#{(seconds / 60).to_i}m #{seconds % 60}s" if seconds < 3600
  end

  def read_lines
    @read_lines ||= convert_to_utf_8

    @read_lines = @read_lines[1..-1] if @read_lines[0][0..5]=="/EDICT" #Skip first line if standard comment

    @read_lines
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
