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

  def send_friend_request_email(user, friend)
    described_class.send_friend_request(user: user, friend: friend).deliver_now
  end
end
