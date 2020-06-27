class UserGamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_game, only: [:update]

  def update
    user_game_service = UserGameService.new(@user_game, user_game_params)

    if user_game_service.update
      flash[:notice] = "You successfully updated #{@user_game.game_name}!"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "There was an error updating the game."
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    game = Game.find(params[:id])

    user_game = UserGame.find_by(user: current_user, game: game)

    if user_game.destroy
      flash[:notice] = "You have successfully removed #{game.name} from your library."
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = "There was an error removing the game from your library."
      redirect_to root_path
    end
  end

  private

  def set_user_game
    @user_game = UserGame.find_by(id: params[:id])
  end

  def user_game_params
    params.permit(:user, :game, :status, :platform)
  end
end
