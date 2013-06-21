require './lib/edict_indexes'
require './lib/edict_entry'

class Dictionaries
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