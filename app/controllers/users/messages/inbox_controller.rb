class Users::Messages::InboxController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :require_permission!, only: [:index, :show]
  before_action :set_message, only: [:show]

  def index
    @messages = Message.includes(:sender).where(recipient_id: @user.id)
  end

  def show
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def set_message
    @message = Message.find_by(id: params[:id])
  end

  def require_permission!
    if current_user != @user
      redirect_to root_url, alert: "You do not have access to this page."
    end
  end
end
