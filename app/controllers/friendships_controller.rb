class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friend, only: [:destroy]

  def create
    friendship = FriendshipService.new(friendship_params)

    if friendship.save
      redirect_with_notice
    else
      render_errors
    end
  end

  def destroy
    friendship = FriendshipService.new(user_id: current_user.id, friend_id: @friend_id)

    if friendship.destroy
      redirect_with_notice(notice: "Friendship removed.")
    else
      render_errors
    end
  end

  private

  def set_friend
    @friend_id = params[:id]
  end

  def friendship_params
    params.require(:friendship).permit(:user_id, :friend_id)
  end

  def redirect_with_notice(notice: "Friendship saved!")
    redirect_to root_url, notice: notice
  end

  def render_errors
    redirect_to root_url, alert: "There was an error with the request."
  end
end
