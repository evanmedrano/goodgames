class UserMailer < ApplicationMailer
  def send_friend_request(user:, friend:)
    @user = user
    @friend = friend

    mail(
      to: friend.email,
      subject: "#{user.name} has sent you a friend request!"
    )
  end

  def send_user_message(recipient:, sender:)
    @recipient = recipient
    @sender = sender

    mail(
      to: recipient.email,
      subject: "#{sender.name} has sent you a message!"
    )
  end

  def send_suggested_games(recipient:, game:, games:)
    @recipient = recipient
    @game = game
    @games = games

    mail(
      to: recipient.email,
      subject: "You beat #{game.name}. What's the game to play?"
    )
  end
end
