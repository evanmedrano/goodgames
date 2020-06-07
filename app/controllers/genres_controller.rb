class GenresController < ApplicationController
  require 'Rawgapi'

  def index
    @genres = Rawgapi.get_all_genres
  end

  def show
    begin
      @genre = Rawgapi.get_genre(params[:id])

      games = Rawgapi.search_all_games(@genre.slug, "genres")
      @games = Game.find_in_db(games)
    rescue TypeError
      flash[:alert] = "Sorry, that genre does not exist in the database"
      redirect_to genres_path
    end
  end
    
end
