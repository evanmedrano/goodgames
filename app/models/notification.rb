class Notification < ApplicationRecord
  belongs_to :actor, class_name: "User", touch: true
  belongs_to :notifiable, polymorphic: true, touch: true
  belongs_to :recipient, class_name: "User", touch: true
end
