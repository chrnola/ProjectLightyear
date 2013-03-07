##
# Responsible for mapping the values stored in the database to Ruby object
#
##

require 'mongo_mapper'
require 'mongo'

#Establish connection to MongoDB, details stored in .env file
conn = Mongo::Connection.new('127.0.0.1')
db = conn.db(ENV['DB_NAME'])
if ENV['DATABASE_USER'] && ENV['DATABASE_PWD']
  auth = db.authenticate(ENV['DATABASE_USER'], ENV['DATABASE_PWD'])
end

MongoMapper.connection = conn
MongoMapper.database = ENV['DB_NAME']

#Define the classes used by MongoMapper to translate the BSON documents from Mongo to Ruby objects
class User
  include MongoMapper::Document
  safe
  
  key :first_name,  String,   :required => true
  key :last_name,   String,   :required => true
  key :username,    String,   :required => true
  key :password,    String,   :required => true
  key :email,       String,   :required => true
  key :phone,       String,
  key :guid,		String,
  key :isAdmin,		Boolean
  timestamps!
end

class LogEntry
  include MongoMapper::Document
  
  key :seats,         Integer,    :default => 1
  key :pickupAt,      String,     :required => true
  key :willPay,       Boolean
end

#finds all routes that have not started yet, sorted by nearest-to-farthest from the given lat/lon pair 
def findNearbyRoutes(lat, lon)
  rs = Route.where(:startLocation => {:$near => [lat.to_f, lon.to_f], :$maxDistance => 1.8}, :startTime => {:$gte => Time.now})
  rs.all
end

#returns all routes that have not yet started
def findAllRoutes()
  Route.where(:startTime => {:$gte => Time.now}).all
end

#creates a new route
#time should be a string in the format "month/day/year hours(24):minutes"
def newRoute(user, from, to, fLat, fLon, tLat, tLon, seats, time, gasMoney, notes, recurrance)
  begin
    r = Route.new
    r.creator = user
    r.from = from
    r.to = to
    r.startLocation = [fLat.to_f, fLon.to_f]
    r.endLocation = [tLat.to_f, tLon.to_f]
    r.availableSeats = seats.to_i
    r.startTime = DateTime.strptime(time, "%m/%d/%Y %H:%M").to_time
    r.gasMoney = gasMoney
    r.notes = notes
    r.recurrance = recurrance.to_i
    r.save
    true
  rescue
    false
  end
  
end

#adds a new user
def newUser(first_name, last_name, username, password, email, phone, gender)
  begin
    u = User.new
    User.ensure_index(:username, :unique => true)
    u.first_name = first_name
    u.last_name = last_name
    u.username = username.downcase
    u.password = password
    u.email = email.downcase
    u.phone = phone
    u.gender = gender if !gender.nil?
    u.save
    true
  rescue
    false
  end
end

# some simple object retrieval methods
def getRouteById(routeId)
  begin
    r = Route.first(:_id => routeId)
    r
  rescue
    nil
  end
end

def getRoutesByUser(user)
  begin
    Route.where(:creator_id => user._id).all
  rescue
    nil
  end
end

def getUserByUsername(username)
  begin
    u = User.first(:username => username.downcase)
    u.feedbacks.sort! { |a,b| b.created_at <=> a.created_at }
    u
  rescue
    nil
  end
end

def getUserById(id)
  begin
    u = User.first(:_id => id)
    u
  rescue
    nil
  end
end

#adds a comment to a user's page
def leaveFeedback(forWho, byWho, comment)
  begin
    if !forWho.nil? && !byWho.nil? && !comment.nil?
      target = getUserByUsername(forWho)
      author = getUserByUsername(byWho)
      f = Feedback.new(:comment => comment, :creator => author)
      target.feedbacks.push(f)
      target.save
      f._id.to_s() #returns the new post's id (for deletion purposes?)
    else
      "failure"
    end
  rescue
    "failure"
  end
end

#used to delete comment from a user's page
def removeFeedback(user, commentId)
  begin
    if !user.nil? && !commentId.nil?
      if !user.feedbacks.nil?
        cmnt = user.feedbacks.find(commentId)
        user.feedbacks.delete_if{|c| c._id == cmnt._id}
        if user.save
          true
        else
          false
        end
      else
        false
      end
    else
      false
    end
  rescue
    false
  end
end

# returns true if not already in database
def checkUsernameAvailable(username)
  if !username.nil?
    u = getUserByUsername(username.downcase)
    if u.nil?
      true
    else
      false
    end 
  else
    false
  end
end

#simple sign-in function
def authenticate(username, password)
  if !username.nil? && !password.nil?
    u = User.first(:username => username, :password => password)
    if u.nil?
      nil
    else
      u
    end
  else
    nil
  end
end

#Checks to see if the given user has already requested a ride/is a rider for that route
def alreadyRider(riders, user)
  begin
    ret = false
    riders.each do |rider|
      if user.username.casecmp(rider.username)
        ret = true
        break
      end
    end
    ret
  rescue
    false
  end
end
  
#Adds a rider to the 'riders' collection for a particular route
def incrementRequest(route, rider)
  begin
    #r = Route.first(:_id => routeId)
    route.riders += [rider]
    route.save
    true
  rescue
    false
  end
end

#wound up not implementing recurrance
def recurranceToS(num)
  case num
  when 0
    "Once"
  when 1
    "Daily"
  when 2
    "Weekly"
  when 3
    "Monthly"
  end
end
