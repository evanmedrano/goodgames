class UserGamesController < ApplicationController
  before_action :authenticate_user!

  def update
    @user_game = UserGame.find_by(id: params[:id])

    if @user_game.update(user_game_params)
      flash[:notice] = "You successfully changed your game status to '#{@user_game.status}'!"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "There was an error updating the game status."
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @game = Game.find(params[:id])

    @user_game = UserGame.find_by(user: current_user, game: @game)

    if @user_game.destroy
        flash[:notice] = "You have successfully removed #{@game.name} from your library."
        redirect_back(fallback_location: root_path)
    else
        flash.now[:alert] = "There was an error removing the game from your library."
        redirect_to root_path
    end
  end

  private
  
    def user_game_params
      params.permit(:user, :game, :status)
    end

end
