require 'rails_helper'

describe "Friendships" do
  describe "#create" do
    context "as a guest user" do
      it "alerts the user that they must sign in first" do
        post friendships_path, params: { friendships: {} }

        expect(flash["alert"]).to include("You need to sign in")
      end
    end

    context "with valid params" do
      it "sets both friendships pending status to false" do
        user, friend = create(:user), create(:user)
        params = { friendship: { user_id: user.id, friend_id: friend.id } }
        create_friendships_for(user, friend)
        sign_in user

        post friendships_path, params: params

        expect(Friendship.count).to eq(2)
        expect(all_friendships_pending?).to eq(false)
      end
    end

    context "with invalid params" do
      it "displays a flash with an error message" do
        sign_in create(:user)

        post friendships_path, params: { friendship: {} }

        expect(flash["alert"]).to include("There was an error")
      end
    end
  end

  def create_friendships_for(user, friend)
    create(:friendship, user: user, friend: friend)
    create(:friendship, user: friend, friend: user)
  end

  def all_friendships_pending?
    friendships.all? { |friendship| friendship.pending == true }
  end

  def friendships
    Friendship.all
  end
end
