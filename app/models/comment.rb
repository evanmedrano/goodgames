class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user, touch: true

  validates :body, presence: true, length: { maximum: 300 }
  validates :title, length: { maximum: 50 }

  default_scope { order(created_at: :desc) }
end
