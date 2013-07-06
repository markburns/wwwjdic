require './lib/all_requires'
require './wwwjdic'
require 'capybara/rspec'
Capybara.javascript_driver = :webkit
Capybara.app = Wwwjdic

RSpec.configure do |config|
  config.order = "random"
  config.include Capybara::DSL

end

module RedisHelpers
  def env
    'test'
  end
end
