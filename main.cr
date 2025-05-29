require "http/server"
require "json"

class User
    include JSON::Serializable

    property id : Int32
    property name : String
    property email : String

    def initialize(@id : Int32, @name : String, @email : String)
    end
end

users = [
    User.new(1, "Atul", "atul@gmail.com"),
    User.new(2, "Aman", "aman@gmail.com")
]

server = HTTP::Server.new do |context|
    request = context.request
    response = context.response

    case request.path
    when "/users"
        response.content_type = "application/json"
        response.print users.to_json
    else
        response.status_code = 404
        response.print "Not Found"
    end
end

server.bind_tcp "0.0.0.0", 8080
puts "Server running on http://localhost:8080"
server.listen

