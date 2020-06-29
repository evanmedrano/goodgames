class Users::GameComparisonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def index
    @g_c_d = GameComparisonDashboard.new(current_user, @user)
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end
end
