class FriendRequestJob < ApplicationJob
  queue_as :mailers

  def perform(user_id:, friend_id:)
    user = User.find_by(id: user_id)
    friend = User.find_by(id: friend_id)

    UserMailer.send_friend_request(user: user, friend: friend).deliver_later
  end
end
