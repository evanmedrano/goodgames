class Users::CompareGamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def index
    @games = Game.joins(:users).where(users: {id: @user.id && current_user.id})
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end
end
