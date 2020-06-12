require 'rails_helper'

feature "user updates a game comment" do
  scenario "as the user who created the comment" do
    VCR.use_cassette("user updates their game comment") do
      user, game = create(:user), create(:game)
      create_comment(user, game)
      visit game_path(game, as: logged_in_user(user))

      click_link "Edit comment"
      submit_form(body: "This game is amazing!")

      expect(game.comments.count).to eq(1)
      expect(page).to have_content("This game is amazing!")
    end
  end

  scenario "as another user visiting games show page" do
    VCR.use_cassette("user updates a game comment as another user") do
      user, game = create(:user), create(:game)
      create(:comment, commentable: game, user: user)
      visit game_path(game, as: logged_in_user)

      expect(page).not_to have_link("Edit comment")
    end
  end

  scenario "as another user visiting edit link directly" do
    VCR.use_cassette("another user visits edit game comment path directly") do
      user, game = create(:user), create(:game)
      comment = create(:comment, commentable: game, user: user)
      visit edit_game_comment_path(game, comment, as: logged_in_user)

      expect(page).to have_content("You do not have access to this page.")
    end
  end

  scenario "that does not exist" do
    VCR.use_cassette("user views game comment that does not exist") do
      game = create(:game)
      visit edit_game_comment_path(game, 1)

      expect(page).to have_content("Game over!")
    end
  end

  scenario "for a game that does not exist" do
    VCR.use_cassette("user views game comment of a non-existing game") do
      visit edit_game_comment_path(1, 1)

      expect(page).to have_content("Game over!")
    end
  end

  def create_comment(user, game)
    create(:comment, commentable: game, user: user)
  end

  def submit_form(options = {})
    fill_in "Title", with: "Great game"
    fill_in "Comment", with: options[:body] || "I rate this game a 5 out of 5!"
    click_button "Update Comment"
  end
end
