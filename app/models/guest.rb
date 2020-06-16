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
end
