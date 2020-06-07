module ApplicationHelper
  def game_statuses
    %w{ Currently\ own Owned Beat Playing Wishlist }
  end

  def top_genres
    %w{ Action Shooter RPG Strategy Puzzle Sports Racing Adventure }
  end

  def top_platforms
    %w{ Playstation\ 4 Xbox\ One Nintendo\ Switch PC iOS Android }
  end

  def convert_to_slug(name)
    case name
    when /Playstation 4/i         then "playstation4"
    when /Xbox One/i              then "xbox-one"
    when /Nintendo Switch/        then "nintendo-switch"
    when /Massively Multiplayer/i then "massively-multiplayer"
    when /RPG/i                   then "role-playing-games-rpg"
    when /Board Games/i           then "board-games"
    else name
    end
  end

  def date_formatter(date)
    Date.parse(date.to_s).strftime("%m-%d-%Y")
  end
end
