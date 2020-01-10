class UserGamesController < ApplicationController
    before_action :authenticate_user!

    def create
        @game = RawgAPI.save_game(params[:user_game][:game_id])

        if @game.save
            @user_game = UserGame.new(game: @game, user: current_user)
        end
        if @user_game.save
            flash[:notice] = "Congrats! You added #{@game.name} to your library!"
            redirect_back(fallback_location: @game)

        else
            flash[:alert] = "You already added this game to your library!"
            redirect_back(fallback_location: root_path)
        end
    end

    def destroy
        @game = Game.find_by(slug: params[:id]) || Game.find_by(id: params[:id])

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
            params.require(:user_game).permit(:game_id, :user_id)
        end
end
