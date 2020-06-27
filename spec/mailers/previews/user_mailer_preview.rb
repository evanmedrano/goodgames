# Preview all emails at http://localhost:3000/rails/mailers/user_mailer

class UserMailerPreview < ActionMailer::Preview
  def send_friend_request
    UserMailer.send_friend_request(user: User.first, friend: User.second)
  end

  def send_user_message
    UserMailer.send_user_message(sender: User.first, recipient: User.second)
  end

  def send_suggested_games
    user = User.where.not(games: nil).first
    game = user.games.first
    games = RawgApi::GameService.set_suggested_games(game)

    UserMailer.send_suggested_games(recipient: user, game: game, games: games)
  end
end
