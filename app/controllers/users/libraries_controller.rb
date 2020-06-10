class Users::LibrariesController < ApplicationController
  before_action :set_library_facade

  def show
    @library.update_games_display if params[:status]
  rescue NoMethodError
    redirect_to root_url, alert: "That user does not exist!"
  end

  private

  def set_library_facade
    user = User.find_by(id: params[:user_id])

    @library = LibraryFacade.new(user, params[:status])
  end
end
