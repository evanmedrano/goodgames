class Friendship < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :friend, class_name: "User", touch: true

  validates :user, uniqueness: { scope: :friend_id }

  def notification_link(user, message = nil)
    if request_was_sent_by?(user)
      "/users/#{user.id}/friendships"
    else
      "/users/#{user.id}/friend_requests"
    end
  end

  private

  def request_was_sent_by?(user)
    user.id == self.request_sent_by
  end
end
