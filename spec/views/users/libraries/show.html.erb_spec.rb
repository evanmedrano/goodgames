require 'rails_helper'

describe "users/libraries/show.html.erb" do
  describe "friendship related buttons" do
    context "when the user is not friends with the library owner" do
      it "shows a send friend request button" do
        set_library
        set_current_user

        render

        expect(rendered).to have_send_friend_request_button
      end
    end

    context "when the user has a pending friend request with the library owner" do
      it "shows a pending friend request button" do
        user, library_owner = create(:user), create(:user)
        create_friendships(user, library_owner, requester: user)
        set_library(library_owner: library_owner)
        set_current_user(current_user: user)

        render

        expect(rendered).to have_friend_request_pending_button
      end
    end

    context "when the user is friends with the library owner" do
      it "shows a friends button" do
        user, library_owner = create(:user), create(:user)
        create_friendships(user, library_owner, requester: user.id)
        update_friendships_pending_status
        set_library(library_owner: library_owner)
        set_current_user(current_user: user)

        render

        expect(rendered).to have_friends_button
      end
    end

    context "when the user is the library owner" do
      it "shows no friendship related buttons" do
        user = create(:user)
        set_library(library_owner: user)
        set_current_user(current_user: user)

        render

        expect(rendered).not_to have_send_friend_request_button
        expect(rendered).not_to have_friend_request_pending_button
        expect(rendered).not_to have_friends_button
      end
    end
  end

  def set_library(library_owner: build_stubbed(:user))
    library_facade = LibraryFacade.new(library_owner)
    assign(:library, library_facade)
  end

  def set_current_user(current_user: build_stubbed(:user))
    allow(view).to receive(:current_user).and_return(current_user)
  end

  def create_friendships(user, friend, requester:)
    create(:friendship, user: user, friend: friend, request_sent_by: requester)
    create(:friendship, user: friend, friend: user, request_sent_by: requester)
  end

  def have_send_friend_request_button
    have_button("Send friend request")
  end

  def have_friend_request_pending_button
    have_button("Friend request pending", disabled: true)
  end

  def have_friends_button
    have_button("Friends", disabled: true)
  end

  def update_friendships_pending_status
    Friendship.update_all(pending: false)
  end
end
