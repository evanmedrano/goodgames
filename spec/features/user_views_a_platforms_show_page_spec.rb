require 'rails_helper'

feature "user views a platforms show page" do
  scenario "to see how many games they have of the platform in their library" do
    VCR.use_cassette("user views platform show page to see games in library") do
      user, game = create(:user), create(:game, platforms: [{ name: "PC" }])
      user.games << game

      visit platform_path("pc", as: logged_in_user(user))

      expect(page).to have_content("You currently have 1 PC game")
    end
  end
end
