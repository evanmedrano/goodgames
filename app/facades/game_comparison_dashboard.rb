class GameComparisonDashboard
  def initialize(current_user, other_user)
    @current_user = current_user
    @other_user = other_user
  end

  def other_users_games
    games_not_in_common
  end

  def total_games_not_in_common_for(user)
    user.games.size - games_in_common.size
  end

  def percentage_in_common_for(user)
    percentage = (games_in_common.size.to_f / user.games.size * 100).floor

    "#{percentage}%"
  end

  def game_status_for(game, user)
    game
  end

  def games_in_common
    find_games_in_common.to_a
  end

  private

  attr_reader :current_user, :other_user

  def games_not_in_common
    @_games_not_in_common ||= Game.
                                joins(:users).
                                where.
                                not(id: find_games_in_common).
                                where(users: { id: other_user })
  end

  def find_games_in_common
    @_find_games_in_common ||= Game.
                                 includes(:user_games).
                                 joins(:users).
                                 where(user_games: { user_id: users }).
                                 group('games.id').
                                 having("count(*) = ?", users.size)
  end

  def users
    [current_user, other_user]
  end
end
