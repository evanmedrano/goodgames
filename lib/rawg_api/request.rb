require 'httparty'

module RawgApi
  class Request
    include HTTParty
    base_uri "api.rawg.io"
    USER_AGENT = { "User-Agent" => "GoodGames (+gooooodgames.herokuapp.com)" }

    def get(path, options = {})
      super(path, { headers: USER_AGENT, debug_output: STDOUT }.merge(options))
    end
  end
end
