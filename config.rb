# Sinatra configs
enable :sessions

# App configs
APP_PASS = '123456'

# AR configs
ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'app.db'
)
