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
    response = context.response
    reponse.context_type = "application/json"
    case context.request.method
    when "GET"
        case context.request.path
        when "/"
            reponse.print(users.to_join)
        when %r{^/users/(\d+)$}
            id = context.request.path.split("/").last.to_i
            user = users.find { |u| u.id == id}
            if user 
                reponse.print(user.to_json)
            else
                response.status_code = 404
                response.print({"message" => "User not found"}.to_json)
    

