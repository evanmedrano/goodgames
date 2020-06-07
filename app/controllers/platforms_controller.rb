class PlatformsController < ApplicationController
  require 'Rawgapi'

  def index
    @platforms = Rawgapi.get_all_platforms
  end

  def show
    begin
      @platform = Rawgapi.get_platform(params[:id])
      games = Rawgapi.search_all_games(@platform.id, "platforms")
      @games = Game.find_in_db(games)
    rescue TypeError
      flash[:alert] = "Sorry, that platform does not exist in the database"
      redirect_to platforms_path
    end
  end
end
