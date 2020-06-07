require 'httparty'

module RawgApi
  class Request
    include HTTParty
    base_uri "api.rawg.io/api"
    headers "User-Agent" => "GoodGames (+gooooodgames.herokuapp.com)"

    def get(path, options = {})
      super(path, options)
    end
  end
end
