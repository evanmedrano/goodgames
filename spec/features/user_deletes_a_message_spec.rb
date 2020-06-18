require 'rails_helper'

feature "user deletes a message" do
  scenario "from the inbox index screen" do
    user = create(:user)
    user.received_messages << create(:message)

    visit user_inbox_index_path(user, as: logged_in_user(user))
    click_link "Delete message"

    expect(user.received_messages.count).to eq(0)
    expect(page).to have_content("There are no messages in this folder.")
  end

  scenario "from the sent index screen" do
    user = create(:user)
    user.sent_messages << create(:message)

    visit user_sent_index_path(user, as: logged_in_user(user))
    click_link "Delete message"

    expect(user.sent_messages.count).to eq(0)
    expect(page).to have_content("There are no messages in this folder.")
  end

  scenario "from the inbox show screen" do
    user, sender = create(:user)
    user.received_messages << create(:message)
    message = user.received_messages.first

    visit user_inbox_path(user_id: user, id: message, as: logged_in_user(user))
    click_button "Delete message"

    expect(page).to have_content("Message deleted")
    expect(user.received_messages.count).to eq(0)
  end

  scenario "from the sent show screen" do
    user, sender = create(:user)
    user.sent_messages << create(:message)
    message = user.sent_messages.first

    visit user_sent_path(user_id: user, id: message, as: logged_in_user(user))
    click_button "Delete message"

    expect(page).to have_content("Message deleted")
    expect(user.sent_messages.count).to eq(0)
  end
end
