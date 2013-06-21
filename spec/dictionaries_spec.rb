#encoding: utf-8
require File.expand_path('spec/spec_helper')
require './db/dictionaries'
require './app/models/edict_entry'
require './app/data_access/redis_helpers'

describe Dictionaries do
  include RedisHelpers

  before(:all) do
    clear_redis
    @dictionary = Dictionaries.new :edict => './spec/fixtures/edict_small'
  end

  it "starts the server" do
    lambda{r=Redis.new; r.dbsize}.should_not raise_error Errno::ECONNREFUSED
  end

  it "builds the database" do
    @dictionary.rebuild_database!
    @dictionary.num_entries.should == 92
  end
end
