# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "geocoder"                                                                    #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

flights_table = DB.from(:flights)
bookings_table = DB.from(:bookings)
users_table = DB.from(:users)

before do
    # SELECT * FROM users WHERE id = session[:user_id]
    @current_user = users_table.where(:id => session[:user_id]).to_a[0]
    puts @current_user.inspect
end

# flight selection page (all flights) **First page of this app thing
get "/" do
    # before stuff runs
    @flights = flights_table.all
    #@flight = flights_table.where(:id => params["id"]).to_a[0]
    #@bookings = bookings_table.where(:flight_id => params["id"]).to_a
    #@users_table = users_table
    view "flights" #Sends it to "flights" which is the erb(html) file of that screen
end

# show a single flight
#get "/flights/:id" do
    #@users_table = users_table
     #@flight = flights_table.where(:id => params["id"]).to_a[0]
     #@bookings = bookings_table.where(:flight_id => params["id"]).to_a
    #view "flight"
#end

# Form to create a new booking
get "/flights/:id/bookings/new" do
    @flight = flights_table.where(:id => params["id"]).to_a[0]
    #@users_table = users_table
    @bookings = bookings_table.where(:flight_id => params["id"]).to_a
    view "new_booking"
end

# Receiving end of new booking form
post "/flights/:id/bookings/create" do
    bookings_table.insert(:flight_id => params["id"],
                       :user_id => @current_user[:id],
                       :seat_chosen => params["seat_chosen"])
    #@flight = flights_table.where(:id => params["id"]).to_a[0]
    @bookings = bookings_table.where(:flight_id => params["id"]).to_a
    view "create_booking"
end

# Form to create a new user
get "/users/new" do
    view "new_user"
end

# Receiving end of new user form
post "/users/create" do
    users_table.insert(:name => params["name"],
                       :email => params["email"],
                       :password => params["password"],
                       :credit_number => params["credit_number"],
                       :credit_exp_date => params["credit_exp_date"],
                       :credit_security => params["credit_security"])
    view "create_user"
end

# Form to login
get "/logins/new" do
    view "new_login"
end

# Receiving end of login form
post "/logins/create" do
    puts params
    email_entered = params["email"]
    password_entered = params["password"]
    # SELECT * FROM users WHERE email = email_entered
    user = users_table.where(:email => email_entered).to_a[0]
    if user
        puts user.inspect
        # test the password against the one in the users table
        if user[:password] == password_entered
            session[:user_id] = user[:id]
            view "create_login"
        else
            view "create_login_failed"
        end
    else 
        view "create_login_failed"
    end
end

# Logout
get "/logout" do
    view "logout"
end
