class UserGamesController < ApplicationController
  before_action :authenticate_user!

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

end
