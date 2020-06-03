# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :flights do
  primary_key :id
  String :flight_num
  String :origin
  String :destination
  String :date
  String :dep_time
  String :arr_time
  String :price
  
end
DB.create_table! :bookings do
  primary_key :id
  foreign_key :flight_id
  foreign_key :user_id
  String :seat_chosen
  Boolean :taken_1a
  Boolean :taken_1b
  Boolean :taken_2a
  Boolean :taken_2b
  Boolean :taken_3a
  Boolean :taken_3b
  Boolean :taken_4a
  Boolean :taken_4b


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


# Insert initial (seed) data
flights_table = DB.from(:flights)

flights_table.insert(flight_num: "1",
                    origin: "Mexico",
                    destination: "Monterrey",
                    date: "June 21",
                    dep_time: "8:00 AM",
                    arr_time: "9:30 AM",
                    price: "$ 1,200 MXN")
                    

flights_table.insert(flight_num: "2",
                    origin: "Mexico",
                    destination: "Monterrey",
                    date: "June 21",
                    dep_time: "11:00 AM",
                    arr_time: "12:30 PM",
                    price: "$ 1,400 MXN")