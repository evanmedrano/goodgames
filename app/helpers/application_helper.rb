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
    slug = case name
      when "Playstation 4" then "playstation4"
      when "Xbox One" then "xbox-one"
      when "Nintendo Switch" then "nintendo-switch"
      when "RPG" then "role-playing-games-rpg"
      else name
    end
    slug
  end

end
