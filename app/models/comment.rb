class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :user, :game, :title, :body, presence: true 

  delegate :first_name, to: :user, prefix: true
end
