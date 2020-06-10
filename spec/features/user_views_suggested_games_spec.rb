require 'rails_helper'

feature "user views suggested games" do
  scenario "from the games index page" do
    VCR.use_cassette("user views suggested games from games index page") do
      visit games_path
      game_text = find(".card-title", match: :first).text

      find("a", text: "Games like this", match: :first).click

      expect(page).to have_content "Games like #{game_text}"
    end
  end

  scenario "from the games show page" do
    VCR.use_cassette("user views suggested games from games show page") do
      game = create(:game)

      visit game_path(game.slug)
      find("a", text: "Games like this", match: :first).click

      expect(page).to have_content("Games like #{game.name}")
    end
  end

  scenario "with an invalid slug" do
    VCR.use_cassette("user views suggested games with an invalid slug") do
      invalid_slug = "this-is-an-erroneous-slug"

      visit game_discover_index_path(invalid_slug)

      expect(current_path).to eq("/games")
      expect(page).to have_content("Sorry, that game isn't in our database.")
    end
  end
end
