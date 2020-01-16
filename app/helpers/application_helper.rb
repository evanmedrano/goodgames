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
      when /Playstation 4/i   then "playstation4"
      when /Playstation 3/i   then "playstation3"
      when /Xbox One/i        then "xbox-one"
      when /Xbox 360/i        then "xbox360"
      when /Nintendo Switch/i then "nintendo-switch"
      when /RPG/i             then "role-playing-games-rpg"
      else name
    end
    slug
  end

end
