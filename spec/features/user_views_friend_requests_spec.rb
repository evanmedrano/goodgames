require 'rails_helper'

feature "user views friend requests" do
  scenario "as a guest user" do
    visit user_friend_requests_path(1)

    expect(page).to have_content("You need to sign in")
    expect(current_path).to eq('/users/sign_in')
  end

  scenario "of another user" do
    visit user_friend_requests_path(1, as: logged_in_user)

    expect(page).to have_content("You do not have access")
    expect(current_path).to eq('/')
  end

  scenario "that were sent to other users" do
    user, friend = create(:user), create(:user)
    create_friendships(user, friend)

    visit user_friend_requests_path(user, as: logged_in_user(user))

    expect(page).to have_pending_text_for(friend)
    expect(page).not_to have_button("Accept")
  end

  scenario "that were sent by other users" do
    user, friend = create(:user), create(:user)
    create_friendships(user, friend, requester: friend.id)

    visit user_friend_requests_path(user, as: logged_in_user(user))

    expect(page).to have_content("Friend request from #{friend.name}")
    expect(page).to have_button("Accept")
  end

  scenario "and accepts the request" do
    user, friend = create(:user), create(:user)
    create_friendships(user, friend, requester: friend.id)

    visit user_friend_requests_path(user, as: logged_in_user(user))
    click_button("Accept")

    expect(page).to have_content "Friendship saved!"
    expect(friendships.count).to eq(2)
    expect(all_friendships_are_not_pending?).to be(true)
  end

  def create_friendships(user, friend, requester: user.id)
    create(:friendship, user: user, friend: friend, request_sent_by: requester)
    create(:friendship, user: friend, friend: user, request_sent_by: requester)
  end

  def have_pending_text_for(friend)
    have_content("Friend request sent to #{friend.name} is still pending")
  end

  def all_friendships_are_not_pending?
    friendships.all? { |friendship| friendship.pending == false }
  end

  def friendships
    Friendship.all
  end
end
