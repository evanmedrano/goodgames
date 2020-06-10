require 'rails_helper'

feature "user searches for a game" do
  scenario "that returns a result" do
    VCR.use_cassette("user searches for a game that returns a result") do
      query = "super smash bros"

      visit games_path(query: query)

      expect(page.text).to match(/super smash bros/i)
    end
  end

  scenario "that returns no results" do
    VCR.use_cassette("user searches for a game that returns no results") do
      query = "badquerythatreturnsnoresultsatall"

      visit games_path(query: query)

      expect(page).to have_content("Sorry, that game isn't in our database.")
    end
  end
end
