require 'rails_helper'

feature "user views a friends list" do
  scenario "with no friends" do
    user = create(:user)

    visit user_friendships_path(user)

    expect(page).not_to have_content("Search the friends list")
    expect(page).to have_content("#{user.first_name} has no friends yet")
  end

  scenario "and searches for a friend not on the list" do
    user = create(:user)
    create_friendships(user)

    visit user_friendships_path(user)
    submit_form

    expect(page).to have_content('Nobody with the name of "bad name" was found')
  end

  scenario "and searches for a friend on the list" do
    user = create(:user)
    create_friendships(user)

    visit user_friendships_path(user)
    submit_form(search: "medrano")

    expect(page).to have_content("Evan Medrano")
  end

  scenario "and sorts the list by last name", js: true do
    user = create(:user)
    create_friendships(user)

    visit user_friendships_path(user)
    select "last name", from: "sort_by"

    expect(page.first('.users-friendships__friend-info')).to have_content("Alvin")
  end

  scenario "and removes one of their friends" do
    user = create(:user)
    friend = create(:user, first_name: "Evan", last_name: "Medrano")
    create_friendships_for(user: user, friend: friend, pending: false)

    visit user_friendships_path(user, as: logged_in_user(user))
    click_link "Unfriend", match: :first

    expect(page).to have_content("Friendship removed")
    expect(page).not_to have_content("Evan Medrano")
  end

  def create_friendships(user)
    friend = create(:user, first_name: "Evan", last_name: "Medrano")
    friend_two = create(:user, first_name: "Alvin", last_name: "Jones")
    create_friendships_for(user: user, friend: friend, pending: false)
    create_friendships_for(user: user, friend: friend_two, pending: false)
  end

  def submit_form(search: "bad name")
    fill_in "search", with: search
    click_button "Search"
  end
end
