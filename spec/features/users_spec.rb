require 'rails_helper'

RSpec.feature "Users", type: :feature do
  
  scenario "successfully signs up" do
    user = FactoryBot.build(:user)

    visit root_path
    click_link "Sign up"
    fill_in "Name", with: user.name
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password

    expect {
      click_button "Sign up"
    }.to change(User, :count).by 1
    
  end

  scenario "visits their games library" do
    user = FactoryBot.create(:user)
    game = FactoryBot.create(:game)

    user_game = FactoryBot.create(:user_game, user: user, game: game)

    login_as(user, scope: :user)

    visit root_path
    click_link "My games"

    expect(page).to have_button  "Remove from library" 
    expect(page).to have_content "#{game.name}"
  end

  scenario "visits another user's games library" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)

    game = FactoryBot.create(:game)
    user_game = FactoryBot.create(:user_game, user: other_user, game: game)

    login_as(user, scope: :user)

    visit "/users/#{other_user.id}/games"

    expect(page).to have_button  "Add to library" 
    expect(page).to have_content "#{game.name}"
    
  end
end
