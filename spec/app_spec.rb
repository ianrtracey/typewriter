require_relative '../api/api'

describe "Test API" do
  it "can return a http result" do
    result = API::DummyAPI.test_api_method("foobar")
    expect(result).to eql(301)
  end
end
