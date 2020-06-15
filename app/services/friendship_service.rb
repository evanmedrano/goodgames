class FriendshipService
  def initialize(args = {})
    @user_id = args[:user_id]
    @friend_id = args[:friend_id]
  end

  def pending_friend_request
    if both_friendships_are_valid?
      user_friendships.each(&:save)

      FriendRequestJob.perform_later(user_id: user_id, friend_id: friend_id)
    else
      false
    end
  end

  def save
    if both_friendships_are_persisted?
      update_pending_status
      true
    else
      false
    end
  end

  def destroy
    if both_friendships_are_persisted?
      delete_friendships
      true
    else
      false
    end
  end

  private

  attr_reader :friend_id, :user_id

  def both_friendships_are_valid?
    user_friendships.all?(&:valid?)
  end

  def both_friendships_are_persisted?
    return false if friendships_are_not_persisted

    find_friendships.all?(&:persisted?)
  end

  def delete_friendships
    find_friendships.each(&:destroy)
  end

  def update_pending_status
    find_friendships.each { |friendship| friendship.update(pending: false) }
  end

  def friendships_are_not_persisted
    find_friendships.all? { |friendship| !friendship.respond_to?(:persisted?) }
  end

  def user_friendships
    user_friendship = initialize_friendship(user_id, friend_id, user_id)
    friend_friendship = initialize_friendship(friend_id, user_id, user_id)

    [user_friendship, friend_friendship]
  end

  def find_friendships
    user_friendship = Friendship.find_by(user_id: user_id, friend_id: friend_id)
    friend_friendship = Friendship.find_by(user_id: friend_id, friend_id: user_id)

    [user_friendship, friend_friendship]
  end

  def initialize_friendship(user_id, friend_id, requester)
    Friendship.new(
      user_id: user_id, friend_id: friend_id, request_sent_by: requester
    )
  end
end
