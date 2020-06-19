module Notifiable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :notifiable, dependent: :destroy

    default_scope { order(created_at: :desc) }
  end
end
