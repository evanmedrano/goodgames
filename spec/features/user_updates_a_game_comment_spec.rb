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

  scenario "as another user" do
    VCR.use_cassette("user updates a game comment as another user") do
      user, game = create(:user), create(:game)
      create(:comment, commentable: game, user: user)
      visit game_path(game, as: logged_in_user)

      expect(page).not_to have_link("Edit comment")
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
