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
    response.context_type = "application/json"
    case context.request.method
    when "GET"
        case context.request.path
        when "/"
            response.print(users.to_json)
        when %r{^/users/(\d+)$}
            id = context.request.path.split("/").last.to_i
            user = users.find { |u| u.id == id}
            if user 
                response.print(user.to_json)
            else
                response.status_code = 404
                response.print({"message" => "User not found"}.to_json)
            end
        else
            response.status_code = 404
            response.print({"message" => "Not Found"}.to_json)
        end
    when "POST"
        case context.request.path
        when "/users"
            begin
              user_json = JSON.parse(context.request.body.try(&.gets_to_end) || "{}")
              user = User.new(
                users.size + 1,
                user_json["name"].to_s,
                user_json["email"].to_s
              )
              users << user
              response.status_code = 201
              response.print(user.to_json)
            rescue ex
              response.status_code = 400
              response.print({"message" => "Invalid request: #{ex.message}"}.to_json)
            end 
        else
            response.status_code = 404
            response.print({"message" => "Not Found"}.to_json)
        end
    when "PUT"
        case context.request.path
        when %r{^/users/(\d+)$}
            begin
                id = context.request.path.split("/").last.to_i
                user_json = JSON.parse(context.request.body.try(&.gets_to_end) || "{}")
                user = users.find { |u| u.id == id }
                if user
                    user.name = user_json["name"].to_s if user_json["name"]
                    user.email = user_json["email"].to_s if user_json["email"]
                    response.print(user.to_json)
                else
                    response.status_code = 404
                    response.print({"message" => "User not found"}.to_json)
                end
            rescue ex
                response.status_code = 400
                response.print({"message" => "Invalid request: #{ex.message}"}.to_json)
            end
        else
            response.status_code = 404
            response.print({"message" => "Not found"}.to_json)
        end
        
        


