$: << File.expand_path(File.dirname(__FILE__) + "/lib")

require 'sinatra'
require 'erb'
# gem install mongo_mapper first
#require 'models.rb'

enable :sessions

set :public_folder, File.dirname(__FILE__) + '/public'

get '/?' do
  @message = 'erb test!'
  
  erb :index
end

get '*' do 
  # Return 404 page if nothing is found
  @errurl = request.fullpath();
  erb :pagenotfound
end
