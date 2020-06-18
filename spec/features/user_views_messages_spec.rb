require 'rails_helper'

feature "user views messages" do
  scenario "of another user" do
    user = create(:user, :with_sent_messages)

    visit user_sent_index_path(user, as: logged_in_user)

    expect(page).to have_content("You do not have access to this page.")
  end

  scenario "received from other users" do
    user = create(:user, :with_received_messages)

    visit user_inbox_index_path(user, as: logged_in_user(user))

    expect(page).not_to have_content("There are no messages in this folder.")
  end

  scenario "sent by the user" do
    user = create(:user, :with_sent_messages)

    visit user_sent_index_path(user, as: logged_in_user(user))

    expect(page).not_to have_content("There are no messages in this folder.")
  end

  scenario "after clicking on one in the inbox screen" do
    user = create(:user)
    user.received_messages << create(:message, subject: "Test message!")

    visit user_inbox_index_path(user, as: logged_in_user(user))
    click_link "Test message!"

    expect(page).to have_link("Reply")
  end

  scenario "after clicking on one in the sent messages screen" do
    user = create(:user)
    user.sent_messages << create(:message, subject: "Test message!")

    visit user_sent_index_path(user, as: logged_in_user(user))
    click_link "Test message!"

    expect(page).to have_link("Send another message")
  end
end
