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
    @user_arr = @database_connection.sql("SELECT username FROM users").map { |hsh| hsh["username"].downcase}
    end
    if params[:sort_menu] == "asc"
      @user_arr.sort!
    elsif params[:sort_menu] == "desc"
      @user_arr.sort! { |x,y| y <=> x }
    end
    erb :homepage, :locals => {:username => @username}
  end

  post "/registration/" do
    if params[:username] == "" && params[:password] == ""
      flash[:notice] = "Username and password are required."
      redirect "/registration/"
    elsif params[:password] == ""
      flash[:notice] = "Password is required."
      redirect "/registration/"
    elsif params[:username] == ""
      flash[:notice] = "Username is required."
      redirect "/registration/"
    else
      @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}', '#{params[:password]}')")

      flash[:notice] = "Thank you for registering"

      redirect "/"
    end
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

  get "/logout/" do
    session[:user_id] = nil
    redirect "/"
  end

end
