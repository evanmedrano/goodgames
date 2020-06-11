require 'rails_helper'

feature "user deletes a game comment" do
  scenario "as the user who created the comment" do
    VCR.use_cassette("user deletes a game comment") do
      user, game = create(:user), create(:game)
      create_comment(user, game)
      visit game_path(game, as: logged_in_user(user))

      click_link "Delete comment"

      expect(game.comments.count).to eq(0)
      expect(page).to have_content("Your comment was successfully deleted.")
    end
  end

  scenario "as another user" do
    VCR.use_cassette("user deletes a game comment as another user") do
      user, game = create(:user), create(:game)
      create(:comment, commentable: game, user: user)
      visit game_path(game)

      expect(page).not_to have_link("Delete comment")
    end
  end

  def create_comment(user, game)
    create(:comment, commentable: game, user: user)
  end
end
