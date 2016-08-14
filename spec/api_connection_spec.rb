require_relative '../api/APIConnection'

describe APIConnection do
  it "can create a generic api connection" do
    api_connection = APIConnection.new(:test, :api_token => "foobar")
    expect(api_connection.type).to be_equal(:test)
    expect(api_connection.params).to eql({:api_token => "foobar"})
  end

  it "validates missing required params" do
    expect {
      APIConnection.new(:test, :foobar => "test", :sort_by => "ten")
    }.to raise_error
  end

  it "validates against extraneous params that aren't supported" do
    expect {
      APIConnection.new(:test,
                        :api_token => "test",
                        :sort_by => "ten",
                        :extraneous => "test",
                       )
    }.to raise_error
  end

  it "can build api connections" do
    api_connection = APIConnection.new(:test_builder,
                                       :api_token => "foobar",
                                       :sort_by => "test",
                                      )
    endpoint = "http://tester.iox/foobar?=test"
    expect(api_connection.endpoint).to eql(endpoint)
  end

  it "can make a determine connectivity" do
    api_connection = APIConnection.new(:test,
                                       :api_token => 'test',
                                       :sort_by => "foo"
                                      )
    expect(api_connection.connected?).to be true
  end
end
