require "sinatra"
require "active_record"
require "rack-flash"
require "gschool_database_connection"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])

  end

  get "/" do
    if session[:user_id]
    @username = @database_connection.sql("SELECT username FROM users WHERE id=#{session[:user_id]}").first["username"]
    end
    erb :homepage, :locals => {:username => @username}
  end

  post "/registration/" do
    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}', '#{params[:password]}')")

    flash[:notice] = "Thank you for registering"

    redirect "/"

  end

  get "/registration/" do
    erb :new
  end

  post "/login/" do
    all_users =  @database_connection.sql("Select * from users")
    logged_in_user = all_users.detect do |user_record|
      user_record["username"] == params[:username] && user_record["password"] == params[:password]
    end

    if logged_in_user
      session[:user_id] = logged_in_user["id"]
    end
    redirect "/"

  end



end
