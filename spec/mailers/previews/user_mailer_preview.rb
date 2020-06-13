# Preview all emails at http://localhost:3000/rails/mailers/user_mailer

class UserMailerPreview < ActionMailer::Preview
  def send_friend_request
    UserMailer.send_friend_request(user: User.first, friend: User.second)
  end
end
