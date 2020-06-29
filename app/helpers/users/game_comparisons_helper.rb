module Users::GameComparisonsHelper
  def circle_size_for(user, overlap = nil)
    size_calculation = (user.games.size * 20).to_s + "px"
    base_style = "height: #{size_calculation}; width: #{size_calculation};"

    if overlap
      overlap = (overlap * 20).to_s + "px"

      base_style + "margin-left: -#{overlap}"
    else
      base_style
    end
  end
end
