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

        Game.new(response)
      end

      def set_related_game_content(game)
        get_suggested_games(game)
        get_series_games(game)
        get_screenshots(game)
      end

      def get_suggested_games(game)
        response = RawgApi::Request.get("/games/#{game.slug}/suggested")

        games = fetch_games(response)

        game.suggested_games = games
      end

      private

      def get_series_games(game)
        response = RawgApi::Request.get("/games/#{game.slug}/game-series")

        games = fetch_games(response)

        game.series_games = games
      end

      def get_screenshots(game)
        response = RawgApi::Request.get("/games/#{game.slug}/screenshots")

        screenshots = response.fetch("results", [])

        game.screenshots = screenshots
      end

      def fetch_games(response)
        games = response.fetch("results", []).map { |game| Game.new(game) }

        ::Game.find_in_db(games)
      end
    end

    def initialize(args = {})
      super(args)
      self.clip = args["clip"]["clip"] if self.clip.respond_to?(:[])
    end

    def save
      game = find_or_create_game(self)

      if game.valid?
        game.save
      else
        false
      end
    end

    private

    def find_or_create_game(game)
      ::Game.find_or_initialize_by(slug: game.slug).tap do |g|
        if g.invalid?
          response = game.class.find(game.slug)

          response.instance_values.each do |attribute, value|
            unless attribute == 'id'
              g.send("#{attribute}=", value) if g.respond_to?("#{attribute}=")
            end
          end
        end
      end
    end
  end
end
