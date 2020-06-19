class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def index
    respond_to do |format|
      format.html { notifications }
      format.json { unread_notifications }
    end
  end

  def mark_as_read
    unread_notifications.update_all(read_at: Time.zone.now)
    render json: {success: true}
  end

  private

  def notifications
    @notifications = Notification.where(recipient: current_user)
  end

  def unread_notifications
    @notifications = Notification.where(recipient: current_user).unread
  end
end
