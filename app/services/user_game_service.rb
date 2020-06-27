class UserGameService
  def initialize(user_game, params = {})
    @user_game = user_game
    @params = params
  end

  def update
    if user_game.update(params)
      suggest_new_games_to_play
      true
    else
      false
    end
  end

  private

  attr_reader :params, :user_game

  def check_if_user_beat_game
    if user_beat_game?
      suggest_new_games_to_play
    end
  end

  def user_beat_game?
    params[:status] == "Beat"
  end

  def suggest_new_games_to_play
    SuggestGamesJob.perform_later(user: user, game: game)
  end

  def user
    user_game.user
  end

  def game
    user_game.game
  end
end
