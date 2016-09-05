require './api/api'
require './api/APIConnection'
require './db/db_connection'
require 'securerandom'
require 'sidekiq/api'
require 'sinatra'
require './workers/form_import_worker'

class Typewriter < Sinatra::Base

  enable :sessions
  db = DBConnection.new
  user_collection = db.users
  sidekiq_stats = Sidekiq::Stats.new

  before do
  #   pass if ["/login", '/signup'].include? request.path_info
  #   if session[:user_id].nil?
  #     redirect '/login'
  #   else
  #     @current_user ||= user_collection.find({user_id:session[:user_id]}).first
  #   end
  end

  get '/' do
    # need to hash the typeform_api key
    if session[:user_id].nil?
      redirect '/login'
    else
      redirect '/home'
    end
  end
  get '/login' do
    erb :login
  end

  post '/auth-test' do
    username = params[:username]
    password = params[:password]

    content_type :json
    user = user_collection.find({ username: params[:username]}).first
    if user.nil?
      halt 401
    end
    if user[:password] != params[:password]
      halt 401
    end

    { token: token(username)}.to_json
  end

  def token(username)
    JWT.encode payload(username), ENV['JWT_SECRET'], 'HS256'
  end

  def payload(username)
    {
      exp: Time.now.to_i + 60 *60,
      iat: Time.now.to_i,
      iss: ENV['JWT_ISSUER'],
      scopes: ['get_forms'],
      user: {
        username: username
      }
    }
  end

  get '/job-test' do
    FormImportWorker.perform_async(@current_user, "foobar")
    "submitted"
  end

  post '/login' do
    user = user_collection.find({ username: params[:username]}).first
    if user.nil?
      redirect '/login'
    end
    if user[:password] != params[:password]
      redirect '/login'
    end
    session[:user_id] = user[:user_id]
    redirect '/home'
  end

  get '/signup' do
    erb :signup
  end

  post '/signup' do
    if params[:username].nil? || params[:password].nil?
      redirect '/signup'
    else
      user_id = SecureRandom.uuid
      user_collection.insert_one({
        :user_id => user_id,
        :username => params[:username],
        :password => params[:password],
        :forms => [],
        :api_key => ""
      })
      session[:user_id] = user_id
      redirect '/setup'
    end
  end

  get '/home' do
    if @current_user[:api_key].empty? || @current_user[:forms].empty?
      redirect '/setup'
    end
    @forms = @current_user[:forms]
    erb :home
  end

  get '/forms/:form_id' do
    # response = API::Typeform.get_form(params[:form_id],
                                      # 1,
                                      # user_collection.find.first[:api_key])
    # form_collection = db.forms
    # form_collection.insert_one(
    #   {
    #     form_id: params[:form_id],
    #     user_id: user_collection.find.first[:user_id],
    #     questions: response.questions,
    #     form: response.form,
    #     states: ['hello','world'],
    #     actions: []
    #   }
    # )
    @questions = db.forms.find({form_id: params[:form_id]},
                               {:projection => {'questions' => 1}}).to_a[1]
    erb :form
  end

  get '/setup' do
    if @current_user[:api_key].empty?
      erb :setup_key
    elsif @current_user[:forms].empty?
      key = user_collection.find.first[:api_key]
      @forms = API::Typeform.get_forms(key=key)
      erb :setup_form
    else
      redirect '/home'
    end
  end

  post '/setup' do
    unless params[:api_key].nil?
      user_collection.update_one({
        user_id: @current_user[:user_id]},
        { '$set' => { 'api_key' => params[:api_key] }}
      )
    end
    unless params[:selected_forms].nil?
      user_collection.update_one({
        user_id: @current_user[:user_id]},
        { '$set' => { 'forms' => params[:selected_forms] }}
      )
    end
    redirect '/setup'
  end
end
