class DashboardFacade
  def initialize(user)
    @user = user
  end

  def games_playing
    user.games.where(user_games: { status: "Playing" }).limit(3)
  end

  def games_to_play
    user.games.where(user_games: { status: "Wishlist" }).limit(3)
  end

  def game_shelves_count
    game_shelves = Hash.new

    game_statuses.each { |status| game_shelves[status] = 0 }

    count_user_games(game_shelves)
  end

  def game_recommendation
    if user.games.any?
      find_game_to_recommend
    else
      Game.all.sample
    end
  end

  private

  attr_reader :user

  def game_statuses
    %w[Currently\ own Owned Beat Playing Wishlist]
  end

  def count_user_games(game_shelves)
    user.user_games.pluck(:status).each do |user_game_status|
      game_shelves[user_game_status] += 1
    end

    game_shelves
  end

  def find_game_to_recommend
    game = user.games.sample

    RawgApi::GameService.set_suggested_games(game)

    game.suggested_games.sample
  end
end
