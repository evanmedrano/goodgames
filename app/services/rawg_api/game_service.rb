module RawgApi
  class GameService
    class << self
      def all(query = '', params = 'search')
        query = CGI.escape(query)
        response = RawgApi::Request.get("/games?#{params}=#{query}")

        parse_games(response)
      end

      def find(game)
        response = RawgApi::Request.get("/games/#{game}")

        Game.new(response)
      end

      def set_related_game_content(game, user = {})
        set_suggested_games(game)
        set_series_games(game)
        set_screenshots(game)
        set_users_playing(game, user).first(5)
        set_users_finished(game, user).first(5)
      end

      def set_suggested_games(game)
        response = RawgApi::Request.get("/games/#{game.slug}/suggested")

        games = parse_games(response)

        game.suggested_games = games
      end

      private

      def set_series_games(game)
        response = RawgApi::Request.get("/games/#{game.slug}/game-series")

        games = parse_games(response)

        game.series_games = games
      end

      def set_screenshots(game)
        response = RawgApi::Request.get("/games/#{game.slug}/screenshots")

        screenshots = response.fetch('results', [])

        game.screenshots = screenshots
      end

      def set_users_playing(game, user)
        game.users_playing =
          User.same_game_status(
            current_user: user, game: game, status: 'Playing'
          )
      end

      def set_users_finished(game, user)
        game.users_finished =
          User.same_game_status(current_user: user, game: game, status: 'Beat')
      end

      def parse_games(response)
        games = response.fetch('results', []).map { |game| Game.new(game) }

        ::Game.find_in_db(games)
      end
    end
  end
end
