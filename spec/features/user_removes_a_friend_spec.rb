require 'rails_helper'

feature "user removes a friend" do
  scenario "by way of a friend request sent by another user" do
    user, friend = create(:user), create(:user)
    create_friendships_for(user: user, friend: friend, requester: friend.id)
    visit user_friend_requests_path(user, as: logged_in_user(user))

    click_button "Delete"

    expect(page).not_to have_content ("Friend request sent by")
    expect(Friendship.count).to eq(0)
  end

  scenario "by way of a friend request sent by the current user" do
    user, friend = create(:user), create(:user)
    create_friendships_for(user: user, friend: friend, requester: user.id)
    visit user_friend_requests_path(user, as: logged_in_user(user))

    click_button "Delete"

    expect(page).not_to have_content ("is still pending")
    expect(Friendship.count).to eq(0)
  end

  scenario "when they are already friends" do
    user, friend = create(:user), create(:user)
    create_friendships_for(user: user, friend: friend, pending: false)
    visit user_library_path(friend, as: logged_in_user(user))

    click_button "Remove friend"

    expect(page).to have_content ("Friendship removed.")
    expect(Friendship.count).to eq(0)
  end
end
