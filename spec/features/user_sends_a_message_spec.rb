require 'rails_helper'

feature "user sends a message" do
  scenario "successfully" do
    recipient, sender = create(:user), create(:user)

    visit user_library_path(recipient, as: logged_in_user(sender))
    click_link "Message"
    submit_form

    expect(Message.count).to eq(1)
    expect(recipient.received_messages.count).to eq(1)
    expect(sender.sent_messages.count).to eq(1)
  end

  def submit_form
    fill_in "Subject", with: "Hey!"
    fill_in "Message", with: "It's a test!"
    click_button "Send message"
  end
end
