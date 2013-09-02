enable :sessions

get '/' do
	if logged_in?
		@current_user = User.find(session[:user_id])
	else
		@current_user = nil
	end
  @users = User.order("created_at DESC")
  erb :index
end

#----------- SESSIONS -----------

get '/sessions/new' do
  erb :sign_in
end

post '/sessions' do
  if user = User.authenticate(params[:email], params[:password])
  	session[:user_id] = user.id
  end
  redirect to('/')
end

delete '/sessions/:id' do
	session[:user_id] = nil
	redirect to ('/')
end

#----------- USERS -----------

get '/users/new' do
  erb :sign_up
end

post '/users' do
	@new_user = User.create(params[:user])
	if @new_user.valid?
		session[:user_id] = @new_user.id
		redirect to('/')
	else
  	@errors = @new_user.errors.full_messages
  	erb :sign_up
	end
end
