require 'sinatra'
require 'active_record'
require_relative 'config'
require_relative 'models/book'

# Index route
get '/' do                   
  @books_reading = Book.find_by_status 'reading'
  @books_unread  = Book.find_by_status 'unread'
  @books_read    = Book.find_by_status 'read'
  @books_next    = Book.find_by_status 'next'
  erb :index
end

# Book creation
get '/new' do
  @book = Book.new
  erb :new
end

post '/new' do
  @book = Book.new(params[:book])
  
  if @book.save
    session[:message] = 'The book was created.'
    redirect '/'
  else
    session[:message] = @book.errors.full_messages.join('<br/>')
    erb :new
  end
end

# Book edition
get '/edit/:id' do |id|
  @book = Book.find(id)
  erb :edit
end

post '/edit/:id' do |id|
  @book = Book.find(id)  
  
  if @book.update_attributes(params[:book])
    session[:message] = 'The book was updated.'
    redirect '/'
  else
    session[:message] = @book.errors.full_messages.join('<br/>')
    erb :edit
  end
end

# Book destruction
delete '/delete/:id' do |id|
  @book = Book.find(id)
  
  if @book.destroy
    session[:message] = 'The book was deleted.'
  else
    session[:message] = "The book couldn't be deleted."
  end
end

# Auth routes
get '/login' do
  erb :login
end

post '/login' do
  if params[:password] == APP_PASS
    session[:auth] = true
    redirect '/'
  else    
    session[:message] = 'Wrong password.'
    erb :login
  end
end

get '/logout' do
  session[:auth] = nil  
  session[:message] = 'You have logged out.'
  redirect '/'
end

# Helpers
helpers do
  def base_url
    request.base_url
  end
end

# Filters
before do
  # Valida autenticação
  if session[:auth].nil? && request.path_info !~ /login|\/$/
    redirect '/login'
  end
end
