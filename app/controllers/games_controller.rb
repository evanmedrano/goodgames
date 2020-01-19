class GamesController < ApplicationController
  require 'Rawgapi'
  before_action :authenticate_user!, only: [:create]
  before_action :set_game, only: [:show, :discover]

  def index
    #? Sets the search response to either the name from a user search or it defaults as an empty search which loads a list of games
    response = params[:query].presence || "''" 

    games = RawgAPI.search_all_games(response)
    @games = Game.find_in_db(games)

    if @games.empty?
    flash.now[:alert] = "Cannot find game in database! Try another search."
      render :search
    end
  end

  def show 
    begin
      set_related_content(@game)
      @comments = @game.comments if @game.is_a?(Game) # Only set the comments for games in the database
    rescue TypeError
      flash[:alert] = "Sorry, that game does not exist in our database!"
      redirect_to games_path
    end
  end

  def create
    game = Game.find_by(slug: params[:game][:slug]) || RawgAPI.get_game(params[:game][:slug])

    @game = Game.find_or_create_by(slug: game.slug) do |new_game|
      game.instance_values.each do |attribute, value|
        # Avoid copying the game's id value from the API and instead increment 
        # the id values from within the app
        new_game.write_attribute(attribute, value) unless attribute == "id"
      end
    end
    
    if @game.save
      current_user.games << @game
      flash[:alert] = "Congrats! You added a new game to your library!"
      redirect_back(fallback_location: @game)
    else
      flash[:alert] = "There was an error adding #{@game.name} to your library."
      redirect_back(fallback_location: root_path)
    end
  end

  def discover 
    games = RawgAPI.get_game_content(@game.slug, "suggested")
    @games = Game.find_in_db(games)
  end


  private

    def set_game
      @game = Game.find_by(slug: params[:id]) || Game.find_by(id: params[:id]) || RawgAPI.get_game(params[:id])
    end

    def set_related_content(game)
      similar_games = RawgAPI.get_game_content(game.slug, "suggested")
      @similar_games = Game.find_in_db(similar_games)

      @game_screenshots = RawgAPI.get_game_content(game.slug, "screenshots")

      series_games = RawgAPI.get_game_content(game.slug, "game-series")
      @series_games = Game.find_in_db(series_games)

      @users_who_beat_game    = User.same_game_status(game, "Beat", current_user)

      @users_who_are_playing  = User.same_game_status(game, "Playing", current_user)
    end
    
end
