class LibraryFacade
  attr_accessor :games

  def initialize(user, params = {})
    @user = user || Guest.new
    @status = params[:status]
    @page = params[:page]
  end

  def id
    user.id
  end

  def owner
    user.first_name
  end

  def games
    Kaminari.paginate_array(library_games).page(page).per(9)
  end

  private

  attr_reader :user, :status, :page

  def update_games_display
    self.games = Game.filter_by_status(user, status)
  end

  def library_games
    if status
      update_games_display
    else
      user.games
    end
  end
end
