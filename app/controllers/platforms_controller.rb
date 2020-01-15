class PlatformsController < ApplicationController
  require 'Rawgapi'

  def index
    @platforms = RawgAPI.get_all_platforms
  end

  def show
    begin
      @platform = RawgAPI.get_platform(params[:id])
      games = RawgAPI.search_all_games(@platform.id, "platforms")
      @games = Game.find_in_db(games)
    rescue TypeError
      flash[:alert] = "Sorry, that platform does not exist in the database"
      redirect_to platforms_path
    end
  end
end
