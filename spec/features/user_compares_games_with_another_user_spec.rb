require 'rails_helper'

feature "user compares games with another user" do
  scenario "when the other user has no added games to their library" do
    user = create(:user, first_name: "Evan")

    visit user_compare_games_path(user, as: logged_in_user)

    expect(page).to have_content("Evan hasn't added any games.")
  end

  scenario "when the current user has no games in common with the other user" do
    user = create(:user, :with_a_games_library, first_name: "Evan")

    visit user_compare_games_path(user, as: logged_in_user)

    expect(page).to have_content("You and Evan don't have games in common.")
  end

  scenario "when the current user and other user have games in common" do
    current_user, game = create(:user), create(:game)
    other_user = create(:user, :with_a_games_library, first_name: "Evan")

    current_user.games << game
    other_user.games << game


    visit user_compare_games_path(other_user, as: logged_in_user(current_user))

    expect(page).to have_content("Evan's games: 3 (2 not in common)")
    expect(page).to have_content("Games in common: 1")
    expect(page).to have_content("My games: 1 (0 not in common)")
  end
end
