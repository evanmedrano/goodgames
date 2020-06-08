class DiscoverController < ApplicationController
  before_action :set_game

  def index
    raise TypeError if @game.name.nil?
  rescue TypeError
    redirect_to games_url, alert: "Sorry, that game isn't in our database."
  end

  private

  def set_game
    @game = persisted_game? || RawgApi::GameService.find(params[:game_id])

    RawgApi::GameService.set_suggested_games(@game) unless @game.name.nil?
  end

  def persisted_game?
    Game.find_by(slug: params[:game_id]) || Game.find_by(id: params[:game_id])
  end
end
