require 'sinatra'
require 'restclient'
require 'json'

#TODO: Dont use these ids in a real application. Create new ones and hid'em !!!!!!
CI_CLIENT_ID = "870198859363-7fga9rg7nd2mjtqiioil0akvf83eoa5j.apps.googleusercontent.com"
CI_CLIENT_SECRET = "kqdbo_H1yly3vSGCz6SWXzcT"

set :server, "webrick"
set :public_folder, 'public'

get '/' do
  # params = {
  #   response_type: 'code',
  #   client_id: CI_CLIENT_ID,
  #   scope: "email",
  #   redirect_uri: 'http://localhost:4567/callback',
  #   state: "whatever"
  # }
  redirect '/index.html'
end

get '/me' do
  @me = "helge"
  erb :'me'
end


get '/callback' do
  puts "Got callback from google with #{params.to_json}"
  authentication_code = params[:code]
  puts "Got authentication code: #{authentication_code}"

  params = {
      code: authentication_code,
      client_id: CI_CLIENT_ID,
      client_secret: CI_CLIENT_SECRET,
      grant_type: "authorization_code",
      redirect_uri: 'http://localhost:4567/callback'
    }
    
  result = RestClient::Resource.new("https://www.googleapis.com/oauth2/v3/token?#{URI.encode_www_form(params)}").post({})
  access_token_info = JSON.parse(result, symbolize_names: true)  
  puts "Access token info: #{access_token_info}"

  access_token = access_token_info[:access_token]  
  result = RestClient::Resource.new("https://www.googleapis.com/oauth2/v2/userinfo?access_token=#{access_token}").get
  @me_info = JSON.parse(result, symbolize_names: true)  
  puts @me_info
  erb :'me'
end