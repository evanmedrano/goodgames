require 'rails_helper'

describe FriendshipService do
  describe "#pending_friend_request" do
    context "when the user doesn't have the other user as a friend" do
      it "creates 2 pending friendships" do
        user, friend = create(:user), create(:user)
        friendship_service = initialize_friendship_service(user, friend)

        expect {
          friendship_service.pending_friend_request
        }.to change(Friendship, :count).by(2)

        expect(all_friendships_pending?).to be(true)
      end
    end

    context "when the user already has the other user as a friend" do
      it "returns false" do
        user, friend = create(:user), create(:user)
        user_friendship = create(:friendship, user: user, friend: friend)
        friend_friendship = create(:friendship, user: friend, friend: user)
        friendship_service = initialize_friendship_service(user, friend)

        expect(friendship_service.pending_friend_request).to be(false)
        expect(Friendship.all.size).to eq(2)
      end
    end
  end

  describe "#save" do
    context "when both of the mutual friendships are persisted" do
      it "returns true and sets both friendships to false" do
        user, friend = create(:user), create(:user)
        friendship_service = initialize_friendship_service(user, friend)

        friendship_service.pending_friend_request

        expect(friendship_service.save).to be(true)
        expect(all_friendships_pending?).to be(false)
      end
    end
  end

  describe "#destroy" do
    it "removes both friendships involving the users from the database" do
      user, friend = create(:user), create(:user)
      friendship_service = save_friendships_for(user, friend)

      expect(friendship_service.destroy).to be(true)
      expect(friendships.count).to eq(0)
    end
  end

  def all_friendships_pending?
    friendships.all? { |friendship| friendship.pending == true }
  end

  def initialize_friendship_service(user, friend)
    FriendshipService.new(user_id: user.id, friend_id: friend.id)
  end

  def friendships
    Friendship.all
  end

  def save_friendships_for(user, friend)
    initialize_friendship_service(user, friend).tap do |friendship_service|
      friendship_service.pending_friend_request
      friendship_service.save
    end
  end
end
