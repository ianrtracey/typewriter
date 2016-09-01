require './api/api'
require './api/APIConnection'
require './db/db_connection'
require 'securerandom'

class Typewriter < Sinatra::Base

  enable :sessions
  db = DBConnection.new
  user_collection = db.users

  get '/' do
    # need to hash the typeform_api key
    if session[:typeform_api_key].nil? || session[:forms].empty?
      redirect '/setup'
    else
      redirect '/home'
    end
  end

  get '/home' do
    p "forms #{session[:forms]}"
    @forms = user_collection.find.first[:forms]
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
    if user_collection.find.first[:api_key].nil?
      erb :setup_key
    elsif user_collection.find.first[:forms].empty?
      key = user_collection.find.first[:api_key]
      @forms = API::Typeform.get_forms(key=key)
      erb :setup_form
    else
      redirect '/home'
    end
  end

  post '/setup' do
    unless user_collection.find.first[:api_key].nil?
      user_collection.insert_one(
        {
          user_id: SecureRandom.uuid,
          forms: [],
          api_key: params[:typeform_api_key]
        }
      )
    end
    unless params[:selected_forms].empty?
      user_collection.update_many({}, '$set' => { 'forms' => params[:selected_forms]})
    end
    redirect '/setup'
  end
end
