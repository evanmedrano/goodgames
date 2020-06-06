module RawgApi
  class GameService
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

      def set_related_game_content(game, user = {})
        get_suggested_games(game)
        get_series_games(game)
        get_screenshots(game)
        get_users_playing(game, user).first(5)
        get_users_finished(game, user).first(5)
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

      def get_users_playing(game, user)
        game.users_playing = User.same_game_status(game, "Playing", user)
      end

      def get_users_finished(game, user)
        game.users_finished = User.same_game_status(game, "Beat", user)
      end

      def fetch_games(response)
        games = response.fetch("results", []).map { |game| Game.new(game) }

        ::Game.find_in_db(games)
      end
    end
  end
end
