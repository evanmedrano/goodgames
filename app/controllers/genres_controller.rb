class GenresController < ApplicationController
  require 'Rawgapi'

  def index
    #@top_genres = TOP_GENRES

    response = params[:genre].presence || "''" 
    
    unless response.length == 0
      @genres = RawgAPI.search_genres(response).first(10)
      # games = get_games_from_genre(@genres)
      # @games  = Game.find_in_db(games)
      #byebug
    else
      flash[:alert] = "Cannot find genre in database! Try again."
      redirect_to root_path
    end
  end

  def show
    @genre = RawgAPI.get_genre(params[:id])
  end

  private

  def get_games_from_genre(genres)
    games = genres.map { |genre| genre["games"] }
  end
    
  TOP_GENRES = ["Action", "Shooter", "RPG", "Strategy", "Puzzle", "Sports", "Racing", "Adventure"]
    
end
