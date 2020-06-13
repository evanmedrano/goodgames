class FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    if friend_request_sent
      redirect_with_notice
    else
      render_errors
    end
  end

  private

  def friend_request_sent
    friendship = FriendshipService.new(user_id: user_id, friend_id: friend_id)
    friendship.pending_friend_request
  end

  def redirect_with_notice
    flash[:notice] = "Friend request sent."
    redirect_back(fallback_location: root_url)
  end

  def render_errors
    flash[:alert] = "There was an error sending the friend request."
    redirect_back(fallback_location: root_url)
  end

  def user_id
    friend_request[:user_id]
  end

  def friend_id
    friend_request[:friend_id]
  end

  def friend_request
    params.fetch(:friend_request, {})
  end

  def friend_request_params
    params.require(:friend_request).permit(:user_id, :friend_id)
  end
end
