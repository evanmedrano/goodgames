class UsersController < ApplicationController
  
  def games
    begin
      @user = User.find_by(id: params[:id])
      @games = @user.games
    rescue NoMethodError # rescue from a nil @user value
      flash[:alert] = "That user does not exist!"
      redirect_to root_path
    end
  end
  
end
