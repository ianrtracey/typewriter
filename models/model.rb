require_relative '../db/db_connection.rb'

class Model
  def initialize
    @database_client = DBConnection.new.client
    @type = nil
  end

  def save(collection_name, doc)
    collection = @database_client.database[collection_name]
    collection.insert_one(doc)
  end
end
