require 'rails_helper'

feature "user views a genres show page" do
  scenario "to see how many games they have of the genre in their library" do
    VCR.use_cassette("user views genre show page to see games in library") do
      user, game = create(:user), create(:game, genres: [{ name: "Action" }])
      user.games << game

      visit genre_path("action", as: logged_in_user(user))

      expect(page).to have_content("You currently have 1 Action game")
    end
  end
end
