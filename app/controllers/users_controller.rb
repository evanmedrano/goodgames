class UsersController < ApplicationController
  
  def games
    begin
    @user = User.find_by(id: params[:id])
      if params[:status]
        @games = Game.filter_by_status(@user, params[:status])
      else
        @games = @user.games
      end
    rescue NoMethodError # rescue from a nil @user value
      flash[:alert] = "That user does not exist!"
      redirect_to root_path
    end
  end
  
end
