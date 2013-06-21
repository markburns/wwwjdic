require './db/edict_indexes'
require './app/data_access/redis_helpers'

class Dictionaries
  include RedisHelpers

  def initialize options
    @edict = EdictIndexes.new(options[:edict])
  end

  def num_entries
    redis.dbsize
  end

  def rebuild_database!
    @edict.destructive_rebuild_db! :english_definitions, :kana, :kanji, :english_words
  end
end
