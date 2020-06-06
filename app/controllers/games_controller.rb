class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_game, only: [:show]

  def index
    @games = RawgApi::GameService.all(query)

    if @games.empty?
      redirect_to games_url, alert: "Sorry, that game isn't in our database."
    end
  end

  def show
    raise TypeError if @game.name.nil?
  rescue TypeError
    redirect_to games_url, alert: "Sorry, that game isn't in our database."
  end

  def create
    game = RawgApi::Game.new(game_params)

    if game.save
      current_user.games << Game.find_by(slug: game.slug)
      flash[:notice] = 'Congrats! You added a new game to your library!'
      redirect_back(fallback_location: root_url)
    else
      flash[:alert] = "There was an error adding the game to your library."
      redirect_back(fallback_location: root_url)
    end
  end

  private

  def set_game
    @game = persisted_game? || RawgApi::GameService.find(params[:id])

    RawgApi::GameService.set_related_game_content(@game) unless @game.name.nil?
  end

  def query
    params.fetch(:query, '')
  end

  def game_params
    params.require(:game).permit(:slug)
  end

  def persisted_game?
    Game.includes(:comments, :users).find_by(slug: params[:id]) ||
      Game.includes(:comments, :users).find_by(id: params[:id])
  end
end
