require 'mongo'
require 'pry'
require_relative './db_config.rb'

class DBConnection
  include DBConfig

  def initialize(addresses=DBConfig::DB_ADDRESSES, db_name=DBConfig::DB_NAME)
    Mongo::Logger.logger.level = ::Logger::FATAL
    @client = Mongo::Client.new(addresses, :database => db_name)
  end

  def client
    @client
  end

  def forms
    @client[:forms]
  end


end

