module RedisHelpers
  DATABASES = {'development' => 0, 'test' => 1, 'production' => 2}

  def env
    ENV['SINATRA_ENVIRONMENT'] || 'development'
  end

  def clear_redis
    begin
      redis.flushdb
    rescue
      raise Exception.new "redis-server should be running"
    end
  end


  def redis
    @db ||= load_redis
  end

  private
  def load_redis
    r = Redis.new :db => DATABASES[env]

    r.dbsize
    return Redis::Namespace.new("wwwjdic_#{env}", :redis => r)
  rescue
    retries ||= 0
    Rake::Task['redis:start'].invoke
    retries += 1
    puts 'retrying after restarting redis'
    sleep 3
    retry unless retries == 5
    raise Exception.new "Failed to restart redis after 5 retries"
  end
end
