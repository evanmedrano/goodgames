class Users::FriendshipsController < ApplicationController
  before_action :set_user

  def index
    if @user.nil?
      render_errors
    else
      @friends = FriendsListService.new(@user, params).friends
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def render_errors
    render "errors/show"
  end
end
