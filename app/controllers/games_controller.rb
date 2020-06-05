class GamesController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_game, only: %i[show discover]

  def index
    @games = RawgApi::Game.all(query)

    if @games.empty?
      flash.now[:alert] = 'Cannot find game in database! Try another search.'
      render :index
    end
  end

  def show
    begin
      @comments = @game.comments if @game.is_a?(Game) # Only set the comments for games in the database
    rescue TypeError
      flash[:alert] = 'Sorry, that game does not exist in our database!'
      redirect_to games_url
    end
  end

  def create
    game = Game.new(game_params).tap do |game|
      response = RawgApi::Game.find(game.slug)

      response.instance_values.each do |attribute, value|
        unless attribute == 'id'
          game.send("#{attribute}=", value) if game.respond_to?("#{attribute}=")
        end
      end
    end

    if game.save
      current_user.games << game
      flash[:alert] = 'Congrats! You added a new game to your library!'
      redirect_back(fallback_location: root_url)
    else
      flash[:alert] = "There was an error adding #{game.name} to your library."
      redirect_back(fallback_location: root_url)
    end
  end

  def discover
    games = RawgAPI.get_game_content(@game.slug, 'suggested')
    @games = Game.find_in_db(games)
  end

  private

  def set_game
    @game =
      Game.find_by(slug: params[:id]) || Game.find_by(id: params[:id]) ||
        RawgApi::Game.find(params[:id])

    RawgApi::Game.set_related_game_content(@game, "suggested_games", "series_games", "screenshots")
  end

  def game_params
    params.require(:game).permit(:slug)
  end

  def query
    params.fetch(:query, '')
  end

#   def set_related_content(game)
#     @users_who_beat_game =
#       User.same_game_status(game, 'Beat', current_user).first(5)

#     @users_who_are_playing =
#       User.same_game_status(game, 'Playing', current_user).first(5)
#   end
end
