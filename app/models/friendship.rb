class Friendship < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :friend, class_name: "User", touch: true

  validates :user, uniqueness: { scope: :friend_id }
end
