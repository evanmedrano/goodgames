require 'rails_helper'

describe FriendsListService do
  describe "#friends" do
    context "when all the friendships are pending" do
      it "returns an empty array" do
        user = create(:user)
        create_friendships_for(user: user)

        friends_list_service = described_class.new(user)

        expect(friends_list_service.friends).to eq([])
      end
    end

    context "when the friends list is sorted by date added" do
      it "returns the friends list in descending order" do
        user = create(:user)
        first_friend = create(:user)
        second_friend = create(:user)
        create_friendships_for(user: user, friend: first_friend, pending: false)
        create_friendships_for(user: user, friend: second_friend, pending: false)

        friends_list_service = described_class.new(user, sort_by: "date_added")

        expect(friends_list_service.friends).to eq([second_friend, first_friend])
      end
    end

    context "when the friends list is sorted by first name" do
      it "orders the list by first name" do
        user = create(:user)
        first_friend = create(:user, first_name: "Alvin")
        second_friend = create(:user, first_name: "Evan")
        create_friendships_for(user: user, friend: first_friend, pending: false)
        create_friendships_for(user: user, friend: second_friend, pending: false)

        friends_list_service = described_class.new(user, { sort_by: "first_name" })

        expect(friends_list_service.friends).to eq([first_friend, second_friend])
      end
    end

    context "when the friends list is sorted by last name" do
      it "orders the list by last name" do
        user = create(:user)
        first_friend = create(:user, last_name: "Smith")
        second_friend = create(:user, last_name: "Medrano")
        create_friendships_for(user: user, friend: first_friend, pending: false)
        create_friendships_for(user: user, friend: second_friend, pending: false)

        friends_list_service = described_class.new(user, { sort_by: "last_name" })

        expect(friends_list_service.friends).to eq([second_friend, first_friend])
      end
    end

    context "when the friends list is sorted by games added" do
      it "orders the list by most amount of games in a friend's library" do
        user = create(:user)
        first_friend = create(:user)
        second_friend = create(:user, :with_a_games_library)
        create_friendships_for(user: user, friend: first_friend, pending: false)
        create_friendships_for(user: user, friend: second_friend, pending: false)

        friends_list_service = described_class.new(user, { sort_by: "games_added" })

        expect(friends_list_service.friends).to eq([second_friend, first_friend])
      end

      it "orders the list by first name if the games added count is equal" do
        user = create(:user)
        first_friend = create(:user, :with_a_games_library, first_name: "Evan")
        second_friend = create(:user, :with_a_games_library, first_name: "Alvin")
        create_friendships_for(user: user, friend: first_friend, pending: false)
        create_friendships_for(user: user, friend: second_friend, pending: false)

        friends_list_service = described_class.new(user, { sort_by: "games_added" })

        expect(friends_list_service.friends[0].first_name).to eq("Alvin")
      end
    end

    context "when the friends list is sorted by friends added" do
      it "orders the list by most amount of friends" do
        user = create(:user)
        first_friend = create(:user, :with_friends)
        second_friend = create(:user)
        create_friendships_for(user: user, friend: first_friend, pending: false)
        create_friendships_for(user: user, friend: second_friend, pending: false)

        friends_list_service = described_class.new(user, { sort_by: "friends_added" })

        expect(friends_list_service.friends).to eq([first_friend, second_friend])
      end

      it "orders the list by first name if the friends added count is equal" do
        user = create(:user)
        first_friend = create(:user, :with_friends, first_name: "Evan")
        second_friend = create(:user, :with_friends, first_name: "Alvin")
        create_friendships_for(user: user, friend: first_friend, pending: false)
        create_friendships_for(user: user, friend: second_friend, pending: false)

        friends_list_service = described_class.new(user, { sort_by: "friends_added" })

        expect(friends_list_service.friends[0].first_name).to eq("Alvin")
      end
    end

    context "when there is a search param passed" do
      context "when the search yields a matching first name" do
        it "returns a list of users" do
          user = create(:user)
          first_friend = create(:user, first_name: "Evan", last_name: "Medrano")
          create_friendships_for(user: user, friend: first_friend, pending: false)

          friends_list_service = described_class.new(user, { search: "evan" })

          expect(friends_list_service.friends).to eq([first_friend])
        end
      end

      context "when the search yields a matching last name" do
        it "returns a list of users" do
          user = create(:user)
          first_friend = create(:user, first_name: "Evan", last_name: "Medrano")
          create_friendships_for(user: user, friend: first_friend, pending: false)

          friends_list_service = described_class.new(user, { search: "MEDRANO" })

          expect(friends_list_service.friends).to eq([first_friend])
        end
      end

      context "when the search yields a matching full name" do
        it "returns a list of users" do
          user = create(:user)
          first_friend = create(:user, first_name: "Evan", last_name: "Medrano")
          create_friendships_for(user: user, friend: first_friend, pending: false)

          friends_list_service = described_class.new(user, { search: "Evan medrano" })

          expect(friends_list_service.friends).to eq([first_friend])
        end
      end

      context  "when the search yields no match results" do
        it "returns an empty array" do
          user = create(:user)
          first_friend = create(:user, first_name: "Evan", last_name: "Medrano")
          create_friendships_for(user: user, friend: first_friend, pending: false)

          friends_list_service = described_class.new(user, { search: "Alvin" })

          expect(friends_list_service.friends).to eq([])
        end
      end
    end
  end
end
