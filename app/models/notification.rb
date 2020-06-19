class Notification < ApplicationRecord
  belongs_to :actor, class_name: "User", touch: true
  belongs_to :notifiable, polymorphic: true, touch: true
  belongs_to :recipient, class_name: "User", touch: true

  default_scope { order(created_at: :desc) }

  def self.unread
    where(read_at: nil)
  end

  def humanized_type
    notifiable_type.underscore.humanize.downcase
  end
end
