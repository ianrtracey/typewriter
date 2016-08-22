require 'mongo'
require_relative './db_config.rb'
class Connection

  attr_reader :client, :db
  include DBConfig

  def initalize
    @client = Mongo::Client.new(DBConfig::DB_ADDRESSES,
                                :database => DBConfig::DB_NAME)
    @db = client.database
  end
end
