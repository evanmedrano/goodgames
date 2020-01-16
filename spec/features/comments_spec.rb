require 'rails_helper'

RSpec.feature "Comments", type: :feature do

  before do
    @game    = FactoryBot.create(:game)
    @user    = FactoryBot.create(:user)
    @comment = FactoryBot.create(:comment, user: @user, game: @game)
    visit game_path(@game)
  end

  scenario "user adds a comment to a game" do
    login_as(@user, scope: :user)

    click_link "Add a comment"
    
    fill_in "Title",   with: "This is a test title"
    fill_in "Comment", with: "This is my comment"

    expect {
      click_button "Add comment" 
    }.to change(@game.comments, :count).by 1 

    expect(@user.comments.count).to eq 2
    expect(page).to have_content "Successfully added a comment for #{@game.name}!"

    comment = @game.comments.last
    
    expect(page).to have_content "#{comment.title}"
    expect(page).to have_content "#{comment.body}"
    expect(page).to have_content "- #{comment.user_name}"
  end

  scenario "guest tries to add a comment to a game" do
    click_link "Add a comment"

    expect(page.current_path).to eq new_user_session_path
  end

  scenario "another user visits the comments index for a game" do
    other_user = FactoryBot.create(:user)
    login_as(other_user, scope: :user)
    #visit game_path(@game)

    2.times { @game.comments << FactoryBot.create(:comment, game: @game) }

    expect(page).to_not have_content "Edit comment"
    expect(page).to_not have_content "Delete comment"

    click_link "All comments"

    expect(page).to have_content "Showing #{@game.comments.count} comments"
  end

  scenario "user edits their comment" do
    login_as(@user, scope: :user)
    visit game_path(@game)

    click_link "Edit comment"

    fill_in "Title", with: "Better title"
    fill_in "Comment", with: "Better comment"

    expect {
      click_button "Edit comment" 
    }.to change(@game.comments, :count).by 0

    expect(@user.comments.count).to eq 1
    expect(page).to have_content "Successfully updated your comment for #{@game.name}!"

    comment = @game.comments.first
    
    expect(page).to have_content "#{comment.title}"
    expect(page).to have_content "#{comment.body}"
    expect(page).to have_content "- #{comment.user_name}"
  end

  scenario "user deletes their comment" do
    login_as(@user, scope: :user)
    visit game_path(@game)

    expect {
      click_link "Delete comment" 
    }.to change(@game.comments, :count).by -1

    expect(@user.comments.count).to eq 0
    expect(page).to have_content "Successfully deleted your comment for #{@game.name}!"

    expect(page).to_not have_content "#{@comment.title}"
    expect(page).to_not have_content "#{@comment.body}"
    expect(page).to_not have_content "- #{@comment.user_name}"
  end

end
