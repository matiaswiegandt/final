# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :flights do
  primary_key :id
  String :flight_num
  String :date
  String :dep_time
  String :arr_time
  String :price
  String :origin
  String :destination
end
DB.create_table! :bookings do
  primary_key :id
  foreign_key :flight_id
  foreign_key :user_id
  foreign_key :seat_chosen
end
DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
  String :credit_number
  String :credit_exp_date
  String :credit_security
end
DB.create_table! :seats do
  primary_key :id
  foreign_key :booking_id
  String :seat_number
  Boolean :booked
end

# Insert initial (seed) data
flights_table = DB.from(:flights)

flights_table.insert(flight_num: "1",
                    date: "June 21", 
                    dep_time: "8:00 AM",
                    arr_time: "9:30 AM",
                    price: "$ 1,200 MXN",
                    origin: "Mexico",
                    destination: "Monterrey")
                    

flights_table.insert(flight_num: "2",
                    date: "June 21", 
                    dep_time: "11:00 AM",
                    arr_time: "12:30 PM",
                    price: "$ 1,400 MXN",
                    origin: "Mexico",
                    destination: "Monterrey")

seats_table = DB.from(:seats)

seats_table.insert(seat_number: "1a")
seats_table.insert(seat_number: "1b")
seats_table.insert(seat_number: "2a")
seats_table.insert(seat_number: "2b")
seats_table.insert(seat_number: "3a")
seats_table.insert(seat_number: "3b")
seats_table.insert(seat_number: "4a")
seats_table.insert(seat_number: "4b")