class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    friendship = FriendshipService.new(user_id: user_id, friend_id: friend_id)

    if friendship.save
      redirect_with_notice
    else
      render_errors
    end
  end

  private

  def friendship_params
    params.require(:friendship).permit(:user_id, :friend_id)
  end

  def user_id
    friendship[:user_id]
  end

  def friend_id
    friendship[:friend_id]
  end

  def redirect_with_notice
    redirect_to root_url, notice: "Friendship saved!"
  end

  def render_errors
    redirect_to root_url, alert: "There was an error saving the friendship."
  end

  def friendship
    params.fetch(:friendship, {})
  end
end
