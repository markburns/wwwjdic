require 'rubygems'
require 'rake'

load 'lib/tasks/redis.rake'

require './helpers'

module RedisHelpers
  def clear_redis
    begin
      redis.flushdb
    rescue
      raise Exception.new "redis-server should be running"
    end
  end

  def env
    'test'
  end
end
