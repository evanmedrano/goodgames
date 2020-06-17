require "rails_helper"

describe UserMailer do
  describe "#send_friend_request" do
    it "sends the request to the requested friend's email" do
      user, friend = create(:user), create(:user)

      send_friend_request_email(user, friend)

      mail = ActionMailer::Base.deliveries.first
      expect([friend.email]).to eq(mail.to)
    end

    it "displays the requester's name in the email's subject" do
      user, friend = create(:user), create(:user)

      send_friend_request_email(user, friend)

      mail = ActionMailer::Base.deliveries.first
      expect(mail.subject).to include(user.name)
    end
  end

  describe "#send_user_message" do
    it "sends the email to the message recipient" do
      recipient, sender = create(:user), create(:user)

      send_user_message_email(recipient, sender)

      mail = ActionMailer::Base.deliveries.first
      expect([recipient.email]).to eq(mail.to)
    end

    it "displays the message sender's name in the email's subject" do
      recipient, sender = create(:user), create(:user)

      send_user_message_email(recipient, sender)

      mail = ActionMailer::Base.deliveries.first
      expect(mail.subject).to include(sender.name)
    end
  end

  def send_friend_request_email(user, friend)
    described_class.send_friend_request(user: user, friend: friend).deliver_now
  end

  def send_user_message_email(recipient, sender)
    described_class.send_user_message(recipient: recipient, sender: sender).
      deliver_now
  end
end
