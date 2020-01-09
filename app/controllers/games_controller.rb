class GamesController < ApplicationController

    require 'Rawgapi'

    def show
        @game = RawgAPI.get_game(params[:id])
    end

    def search   
        if params[:name]
            response = RawgAPI.search(params[:name])
            
            unless response.length == 0
                @games = response
            else
                flash[:alert] = "Cannot find game in database! Try again."
                redirect_to root_path
            end
        end
    end
end
