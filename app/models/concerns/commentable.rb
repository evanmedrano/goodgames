module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy

    default_scope { order(created_at: :desc) }
  end
end
