class SuggestGamesJob < ApplicationJob
  queue_as :mailers

  def perform(user:, game:)
    games = RawgApi::GameService.set_suggested_games(game)

    games.map(&:save)

    UserMailer.send_suggested_games(recipient: user, game: game, games: games).
      deliver_later
  end
end
