module AutoComplete
  extend RedisHelpers

  def self.find(query,count=15)
    results = []
    range_length = count
    start = redis.zrank('auto_complete',query)

    return [] if !start

    while results.length != count
      matches = redis.zrange('auto_complete', start, start + range_length - 1)

      start += range_length

      break if !matches or matches.length == 0

      matches.each do |match|
        min_length = [match.length, query.length].min

        if match[0...min_length] != query[0...min_length]
          count = results.count
          break
        end
        if match[-1] == "*" and results.length != count
          results << match[0...-1]
        end
      end
    end
    results
  end
end
