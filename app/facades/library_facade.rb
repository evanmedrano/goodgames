class LibraryFacade
  attr_accessor :games

  def initialize(user, status = "")
    @user = user
    @status = status
  end

  def id
    user.id
  end

  def owner
    user.first_name
  end

  def games
    @games ||= user.games
  end

  def update_games_display
    self.games = Game.filter_by_status(user, status)
  end

  private

  attr_reader :user, :status
end
