require './api/api'
require './api/APIConnection'

class Typewriter < Sinatra::Base

  enable :sessions

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
    @forms = session[:forms]
    erb :home
  end

  get '/forms/:form_id' do
    params[:form_id]
  end

  get '/setup' do
    if session[:typeform_api_key].nil?
      erb :setup_key
    elsif session[:forms].empty?
      @forms = API::Typeform.get_forms(key=session[:typeform_api_key])
      erb :setup_form
    else
      redirect '/home'
    end
  end

  post '/setup' do
    unless params[:typeform_api_key].nil?
      session[:typeform_api_key] = params[:typeform_api_key]
      session[:forms] = []
    end
    unless params[:selected_forms].nil?
      session[:forms] = params[:selected_forms]
    end
    redirect '/setup'
  end
end
