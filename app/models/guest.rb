class Guest
  GUEST_TRACKING_ID = "guest".freeze

  def id
    GUEST_TRACKING_ID
  end

  def first_name
    nil
  end

  def games
    Array.new
  end

  def added_game?(game)
    false
  end
end
