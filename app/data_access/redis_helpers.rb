module RedisHelpers
  DATABASES = {'development' => 0, 'test' => 1, 'production' => 2}

  def env
    ENV['SINATRA_ENVIRONMENT'] || 'development'
  end

  def clear_redis
    redis.flushdb
  end

  def redis
    @db ||= load_redis
  end

  private
  def load_redis
    r = Redis.new :db => DATABASES[env]

    r.dbsize
    Redis::Namespace.new("wwwjdic_#{env}", :redis => r)
  end
end
