require 'sinatra'
require 'active_record'

# App configs
enable :sessions
APP_PASS = '123456'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'app.db'
)
 
# App models
class Book < ActiveRecord::Base
  attr_accessible :title, :status
  
  validates :title, presence: true
  validates :status, inclusion: { in: ['read', 'unread', 'reading'] }
end

# Index route
get '/' do                   
  @books_reading = Book.where(status: 'reading').order('title ASC')
  @books_unread  = Book.where(status: 'unread').order('title ASC')
  @books_read    = Book.where(status: 'read').order('title ASC')
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
