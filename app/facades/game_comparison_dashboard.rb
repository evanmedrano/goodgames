class GameComparisonDashboard
  def initialize(current_user, other_user)
    @current_user = current_user
    @other_user = other_user
  end

  def games_in_common
    Game.joins(:users).
      where(users: { id: users }).
      group(:id).
      having("count(*) = ?", users.size).
      to_a
  end

  private

  attr_reader :current_user, :other_user

  def users
    [current_user, other_user]
  end
end
