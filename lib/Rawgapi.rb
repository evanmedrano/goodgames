require 'httparty'
require 'cgi' #* Allows us to use the escape method on the search input, so it gets url encoded 

class RawgAPI
    include HTTParty
    base_uri "api.rawg.io"
    GAMES_INDEX_URI = "/api/games?search="
    GAME_URI  = "/api/games/"
    format :json

    def self.search(title)
        response = get(GAMES_INDEX_URI + CGI.escape(title))
        
        if response.success?
            response.parsed_response["results"]
        else
            raise response.response
        end
    end

    def self.get_game(game)
        response = get(GAME_URI + CGI.escape(game))

        if response.success?
            response.parsed_response
        else
            raise response.response
        end
    end
end