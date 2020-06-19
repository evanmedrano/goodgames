class Message < ApplicationRecord
  belongs_to :recipient, class_name: "User", touch:true
  belongs_to :sender, class_name: "User", touch:true

  validates :body, presence: true
  validates :subject, presence: true

  default_scope { order(created_at: :desc) }

  def update_read_status
    update(read: true)
  end

  def notification_link(user, message)
    "/users/#{user.id}/messages/inbox/#{message.id}"
  end
end
