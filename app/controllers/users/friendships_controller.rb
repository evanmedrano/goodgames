class Users::FriendshipsController < ApplicationController
  before_action :set_user

  def index
    @friends = User.all_friends_of(@user)
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end
end
