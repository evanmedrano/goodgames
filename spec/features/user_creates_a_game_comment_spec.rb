require 'rails_helper'

feature "user creates a game comment" do
  scenario "as a guest user" do
    VCR.use_cassette("guest user adds a comment about a game") do
      game = create(:game)
      visit game_path(game)
      click_link "Add a comment"

      submit_form

      expect(game.comments.count).to eq(0)
      expect(page).to have_content("You need to sign in or sign up")
    end
  end

  scenario "successfully" do
    VCR.use_cassette("user successfully adds a comment about a game") do
      game = create(:game)
      visit game_path(game, as: logged_in_user)
      click_link "Add a comment"

      submit_form

      expect(game.comments.count).to eq(1)
      expect(page).to have_content("Your comment was successfully saved.")
    end
  end

  scenario "without a comment body" do
    VCR.use_cassette("user adds a comment without a body") do
      game = create(:game)
      visit game_path(game, as: logged_in_user)
      click_link "Add a comment"

      submit_form(body: "")

      expect(game.comments.count).to eq(0)
      expect(page).to have_content("There was an error leaving a comment.")
    end
  end

  def submit_form(options = {})
    fill_in "Title", with: "Great game"
    fill_in "Comment", with: options[:body] || "I rate this game a 5 out of 5!"
    click_button "Create Comment"
  end
end
