module AutoComplete
  extend RedisHelpers

  def self.find(prefix,count=15)
    results = []
    range_length = count
    start = redis.zrank('auto_complete',prefix)

    return [] if !start

    while results.length != count
      range = redis.zrange('auto_complete', start, start + range_length - 1)

      start += range_length

      break if !range or range.length == 0

      range.each do |entry|
        min_length = [entry.length, prefix.length].min

        if entry[0...min_length] != prefix[0...min_length]
          count = results.count
          break
        end
        if entry[-1] == "*" and results.length != count
          results << entry[0...-1]
        end
      end
    end
    results
  end
end
