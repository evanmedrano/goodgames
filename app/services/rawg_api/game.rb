require 'cgi'

module RawgApi
  class Game < Base
    attr_accessor :suggested_games, :series_games, :screenshots

    class << self
      def all(query)
        query = CGI.escape(query)
        response = RawgApi::Request.get("/games?search=#{query}")

        fetch_games(response)
      end

      def find(game)
        response = RawgApi::Request.get("/games/#{game}")

        Game.new(response).tap do |game|
          game.clip = response["clip"]["clip"]
        end
      end

      def set_related_game_content(game, *related_content)
        game.suggested_games = get_suggested_games(game)
        game.series_games = get_series_games(game)
        game.screenshots = get_screenshots(game)
      end

      private

      def get_suggested_games(game)
        response = RawgApi::Request.get("/games/#{game.slug}/suggested")

        fetch_games(response)
      end

      def get_series_games(game)
        response = RawgApi::Request.get("/games/#{game.slug}/game-series")

        fetch_games(response)
      end

      def get_screenshots(game)
        response = RawgApi::Request.get("/games/#{game.slug}/screenshots")

        response.fetch("results", [])
      end

      def fetch_games(response)
        games = response.fetch("results", []).map { |game| Game.new(game) }

        ::Game.find_in_db(games)
      end
    end

    def initialize(args = {})
      super(args)
    end
  end
end
