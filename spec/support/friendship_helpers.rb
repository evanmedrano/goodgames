module FriendshipHelpers
  def create_friendships_for(options = {})
    new_options = { user: options[:user] || create(:user) }.merge(options)

    create_user_friendship(new_options)
    create_friend_friendship(new_options)
  end

  def create_user_friendship(options = {})
    create(
      :friendship,
      user: options[:user],
      friend: options[:friend] || create(:user),
      pending: options[:pending].nil? ? true : false,
      request_sent_by: options[:requester] || options[:user].id,
    )
  end

  def create_friend_friendship(options = {})
    create(
      :friendship,
      user: options[:friend] || create(:user),
      friend: options[:user],
      pending: options[:pending].nil? ? true : false,
      request_sent_by: options[:requester] || options[:user].id,
    )
  end
end

RSpec.configure do |config|
  config.include FriendshipHelpers
end
