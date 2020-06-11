module TitlesHelper
  def title
    if content_for?(:title)
      "#{content_for :title}"
    else
      "GoodGames | All the games you love in one place"
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
end