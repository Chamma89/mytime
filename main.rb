require 'pry'    
require 'sinatra'
require 'sinatra/reloader'
require_relative 'db_config'
require_relative 'models/location'
require_relative 'models/user'
require_relative 'models/booking'
require_relative 'models/comment'

enable :sessions

helpers do 
	def current_user
		User.find_by(id: session[:user_id])
	end

	def logged_in? 
		if session[:user_id]
			return true
		else
			return false
		end
	end	
end

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
		session[:user_id] = user.id
		redirect '/home'
	else
		erb :login
	end	
end


#HOME PAGE
get '/home' do
	if !session[:user_id]
		return redirect '/login'
	end	
	@comments	= Comment.all

	@location = Location.all
	@tv = @location[0]
	@meeting = @location[1]
	@tv_comment = Comment.where(location_id: 1)
	@meeting_comment = Comment.where(location_id: 2)
	erb :home
end

# TO ADD NEW BOOKING
post '/home/:id/comment' do
	Comment.all.each do |comment|
		if (params[:start_time].to_i >= comment.start && params[:start_time].to_i <= comment.finish) || 
				(params[:end_time].to_i >= comment.start && params[:end_time].to_i <= comment.finish)
				redirect '/home'
		end
	end	
	comment = Comment.new
	comment.start = params[:start_time]
	comment.finish = params[:end_time]

	comment.body = params[:comment]
	comment.location_id = params[:id]
	comment.save
	redirect "/home"
end	


# GETS PAGE WITH COMMENTS TO EDIT
get '/home/edit/:id' do
	@comment = Comment.all
	@edit_comment = @comment.find_by(id: params[:id])
  erb :edit
end


# UPDATES COMMENT
put '/home/edit/:id' do
	comment = Comment.find(params[:id])
	comment.body = params[:comment_update]
	comment.save
	redirect "/home"

end	

get '/home/display/:id' do
	@comment = Comment.all
	@edit_comment = @comment.find_by(id: params[:id])
	@tv_comment = Comment.where(location_id: params[:id])
	@meeting_comment = Comment.where(location_id: params[:id])
	erb :display
end	

delete '/display/:id' do
	comment = Comment.find(params[:id])
	comment.destroy
  redirect '/home'
end

