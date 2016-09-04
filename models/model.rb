require_relative '../db/db_connection.rb'

class Model
  @@database_client = DBConnection.new.client

  def initialize
    @type = nil
  end

  def save(collection_name, doc)
    collection = @@database_client.database[collection_name]
    collection.insert_one(doc)
  end

  def self.find(collection_name, user_id, find_params)
    collection = @@database_client.database[collection_name]
    params = {:user_id => user_id}.merge(find_params)
    collection.find(params)
  end
end
