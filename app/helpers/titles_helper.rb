module TitlesHelper
  def title
    if content_for?(:title)
      "#{content_for :title}"
    else
      default_title
    end
  end

  def games_library_title(library)
    "#{library.owner} - #{library.games.size} games | GoodGames"
  end

  def games_search_title(query)
    if query
      "Search results for #{query} | GoodGames"
    else
      "Find your next favorite game on GoodGames"
    end
  end

  def game_comment_title(game:, comment:)
    if comment.persisted?
      "Edit your comment for #{game.name} | GoodGames"
    else
      "Add a comment for #{game.name} | GoodGames"
    end
  end

  def user_friends_title(user:)
    if user == current_user
      "Friends | GoodGames"
    else
      "#{user.first_name}'s friends | GoodGames"
    end
  end

  def default_title
    "GoodGames | All the games you love in one place"
  end
end
