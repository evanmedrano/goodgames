require 'cgi'

module RawgApi
  class Game < Base
    def self.all(query)
      query = CGI.escape(query)
      response = ::RawgApi::Request.get("/api/games?search=#{query}")

      response.fetch("results", []).map { |game| Game.new(game) }
    end

    def initialize(args = {})
      super(args)
    end
  end
end
