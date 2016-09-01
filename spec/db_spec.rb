require_relative '../db/db_connection'

describe DBConnection do
  before(:each) do
    conn = DBConnection.new(db_name: 'typewriter-test')
    conn.client.database.drop
  end

  it "can create a new instance and access the client" do
    conn = DBConnection.new(db_name: 'typewriter-test')
    expect(conn.client).to_not be_nil
  end

  it "can create and store a form document" do
    conn = DBConnection.new(db_name: 'typewriter-test')
    doc = { form_id: 'foobar', form: {}, states: [], actions: [] }
    form_collection = conn.forms
    result = form_collection.insert_one(doc)
    expect(result.n).to eq(1)
    expect(form_collection.find({}).first).to_not be_nil
    expect(conn.client.database.collections).to_not be_empty
  end
end

