class GenresController < ApplicationController
  before_action :set_genre, only: [:show]

  def index
    @genres = RawgApi::GenreService.all
  end

  def show
    raise TypeError if @genre.name.nil?
  rescue TypeError
    redirect_to genres_path, alert: "Sorry, could not find the genre."
  end

  private

  def set_genre
    @genre = RawgApi::GenreService.find(params[:id])
  end
end
