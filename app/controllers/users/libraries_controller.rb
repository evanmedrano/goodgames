class Users::LibrariesController < ApplicationController
  before_action :set_library_facade

  def show
    if invalid_user_id?
      render_errors
    end
  end

  private

  def set_library_facade
    user = User.find_by(id: params[:user_id])

    @library = LibraryFacade.new(user, { status: status, page: page })
  end

  def invalid_user_id?
    @library.owner.nil?
  end

  def render_errors
    render "errors/show"
  end

  def status
    params[:status]
  end

  def page
    params[:page]
  end
end
