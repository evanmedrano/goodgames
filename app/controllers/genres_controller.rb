class GenresController < ApplicationController
  require 'Rawgapi'

  def index
    @genres = RawgAPI.get_all_genres
  end

  def show
    begin
      @genre = RawgAPI.get_genre(params[:id])

      games = RawgAPI.search_all_games(@genre.slug, "genres")
      @games = Game.find_in_db(games)

      @game_genre_count = Game.filter_by_genre(@genre.name, current_user).size
    rescue TypeError
      flash[:alert] = "Sorry, that genre does not exist in the database"
      redirect_to genres_path
    end
  end
    
end
