class Guest
  GUEST_TRACKING_ID = "guest".freeze

  def id
    GUEST_TRACKING_ID
  end

  def first_name
    nil
  end

  def last_name
    nil
  end

  def games
    Array.new
  end

  def added_game?(game)
    false
  end

  def has_pending_friendship_with?(anybody)
    false
  end

  def is_friends_with?(anybody)
    false
  end

  def sent_friend_request_to?(anybody)
    false
  end

  def is_currently_playing_a_game?
    false
  end

  def currently_playing
    nil
  end

  def can_add_as_a_friend?(anybody)
    false
  end
end
