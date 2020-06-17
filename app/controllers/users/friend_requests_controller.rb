class Users::FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :require_permission!

  def index
    @friend_requests = pending_friend_requests
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def require_permission!
    if incorrect_user?
      redirect_to root_url, alert: "You do not have access to this page."
    end
  end

  def pending_friend_requests
    Friendship.includes(:user).where(user: @user, pending: true)
  end

  def incorrect_user?
    current_user != @user
  end
end
