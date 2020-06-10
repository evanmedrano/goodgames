require 'rails_helper'

feature "user updates game's platform" do
  scenario "to a new platform", js: true do
    VCR.use_cassette("user successfully updates game's platform") do
      user, game = create_user_and_game
      create(:user_game, user: user, game: game, platform: "PC")

      visit game_path(game.slug, as: logged_in_user(user))
      select "PlayStation 3", from: "platform"

      expect(game.current_platform(user)).to eq("PlayStation 3")
      expect(page).to have_content("You successfully updated #{game.name}!")
    end
  end

  def create_user_and_game
    return create(:user), create(:game, slug: "portal-2", platforms: platforms)
  end

  def platforms
    [
      { name: "PC", slug: "pc"},
      { name: "PlayStation 3", slug: "playstation3" },
      { name: "Xbox 360", slug: "xbox360" }
    ]
  end
end
