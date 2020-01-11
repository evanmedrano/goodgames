class GamesController < ApplicationController
  require 'Rawgapi'
  before_action :authenticate_user!, only: [:index]

  def index
    begin
      @user = User.find_by(id: params[:user_id])
      @games = @user.games
    rescue NoMethodError # rescue from a nil @user value
      flash[:alert] = "That user does not exist!"
      redirect_to root_path
    end
  end

  def show 
    begin
      @game = Game.find_by(slug: params[:id]) || Game.find_by(id: params[:id]) || RawgAPI.get_game(params[:id], "games")

      similar_games = RawgAPI.get_similar_games(@game.slug)
      @similar_games = Game.find_in_db(similar_games)

      @game_screenshots = RawgAPI.get_screenshots(@game.slug)

      series_games = RawgAPI.get_game_series(@game.slug)
      @series_games = Game.find_in_db(series_games)
    rescue TypeError
      flash[:alert] = "Sorry, that game does not exist in our database!"
      redirect_to root_path
    end
    
  end

  def search
    #? Sets the search response to either the name from a user search or it defaults as an empty search which loads a list of games
    response = params[:name].presence || "''" 
    
    unless response.length == 0
      games = RawgAPI.search_games(response)
      @games = Game.find_in_db(games)
    else
      flash[:alert] = "Cannot find game in database! Try again."
      redirect_to root_path
    end
  end
    
end
