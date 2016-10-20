ENV['RACK_ENV'] = 'test'

require_relative '../app.rb'
require 'rack/test'

describe "API" do
  include Rack::Test::Methods

  def app
    Typewriter.new!
  end



  it "returns list of forms" do
    get '/v1/api/forms'
    expect(last_response).to be_ok
  end

  it "creates forms" do
    post '/v1/api/forms'
    expect(last_response).to be_ok
  end

  it "returns one form based on form_id" do
    get '/v1/api/forms/foobar'
    expect(last_response).to be_ok
  end

  it "updates forms" do
    put '/v1/api/forms/form_id'
    expect(last_response).to be_ok
  end
end
