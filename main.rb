require 'pry'    
require 'sinatra'
# require 'sinatra/reloader'
require_relative 'db_config'
require_relative 'models/location'
require_relative 'models/user'
require_relative 'models/booking'
require_relative 'models/comment'

get '/' do
  	erb :index
end

get '/login' do
	erb :login
end

get '/register' do
	erb :register
end		

post '/success' do
	user = User.new
	user.email = params[:email]
	user.password = params[:password]
	user.save
	redirect '/success'
end	

get '/success' do
  	erb :success
end

post '/home' do
	user = User.find_by(email: params[:email])
	if user && user.authenticate(params[:password])
		redirect '/home'
	else
		erb :login
	end	
end

get '/home' do
	@locations = Location.all
	@comments = Comment.where(location_id: @locations)
	@tv = @comments.where(location_id:  1)
	@meeting = @comments.where(location_id:  2)
	erb :home
end

post '/home/:id/comment' do
	comment = Comment.new
	comment.body = params[:comment]
	comment.location_id = params[:id]
	comment.save
	redirect "/home"
end	

get '/home/location/:id' do
	@locations = Location.all
	@comments = Comment.where(location_id: @locations)
	@tv = @comments.where(location_id:  1)
	@meeting = @comments.where(location_id:  2)
	erb :edit
end