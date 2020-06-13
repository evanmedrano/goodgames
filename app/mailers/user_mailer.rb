class UserMailer < ApplicationMailer
  def send_friend_request(user:, friend:)
    @user = user
    @friend = friend

    mail(
      to: friend.email,
      subject: "#{user.name} has sent you a friend request!"
    )
  end
end
