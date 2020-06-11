class Users::LibrariesController < ApplicationController
  before_action :set_library_facade

  def show
    @library.update_games_display if params[:status]

    if invalid_user_id?
      redirect_to root_url, alert: "Sorry, that user does not exist."
    end
  end

  private

  def set_library_facade
    user = User.find_by(id: params[:user_id])

    @library = LibraryFacade.new(user, params[:status])
  end

  def invalid_user_id?
    @library.owner.nil?
  end
end
