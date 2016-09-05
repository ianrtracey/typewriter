require_relative '../app'
require 'rack/test'

describe "Sinatra API" do
  include Rack::Test::Methods

  def app
    Typewriter.new
  end

  it "returns information about the api" do
    get '/'
    expect(last_response.status).to eq(200)
  end

  it "allows for new account signup" do
    post '/signup', :username => "foobar", :password => "test", :password_confirmation => "test"
    expect(last_response.status).to eq(200)
  end

  it "allows for the user login" do
    get '/login', :username => "foobar", :password => "test"
    expect(last_response.status).to eq(200)
  end

  it "can set api key" do
    post '/user', :api_key => "foobar"
    expect(last_response.status).to eq(200)
  end

  it "allows for new form creation" do
    post '/forms', :form_id => "testing"
    expect(last_response.status).to eq(200)
  end

  it "can retrieve list of forms" do
    get '/forms'
    expect(last_response.status).to eq(200)
  end

  it "can delete a form" do
    delete '/forms', :form_id => "foobar"
    expect(last_response.status).to eq(200)
  end

  it "can retrieve details of individual forms" do
    get '/forms', :form_id => "foobar"
    expect(last_response.status).to eq(200)
  end








end
