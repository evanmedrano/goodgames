class GamesController < ApplicationController
    require 'Rawgapi'

    def show 
        begin
            @game = Game.find_by(slug: params[:id]) || Game.find_by(id: params[:id]) || RawgAPI.get_game(params[:id])
        rescue TypeError
            flash[:alert] = "Sorry, that game does not exist in our database!"
            redirect_to root_path
        end
    end

    def search
        #? Sets the search response to either the name from a user search or it defaults as an empty search which loads a list of games
        response = params[:name].presence || "''" 
        
        unless response.length == 0
            @games = RawgAPI.search(response)
        else
            flash[:alert] = "Cannot find game in database! Try again."
            redirect_to root_path
        end
    end

end
