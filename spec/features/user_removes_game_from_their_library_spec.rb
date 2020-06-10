require 'rails_helper'

feature "user removes game from their library" do
  scenario "successfully" do
    VCR.use_cassette("user successfully removes game from their library") do
      user, game = create(:user), create(:game, slug: "portal-2")
      user.games << game

      visit game_path(game.slug, as: logged_in_user(user))

      expect {
        click_on_remove_from_library_button
      }.to change(user.games, :count).by(-1)
      expect(user.games.count).to eq(0)
      expect(page).to have_content("You have successfully removed #{game.name}")
    end
  end

  def click_on_remove_from_library_button
    page.find('input[value="Remove from library"]').click
  end
end
