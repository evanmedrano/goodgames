require "rails_helper"

describe UserMailer do
  describe "#confirmation_instructions" do
    it "an email is sent after a user is created" do
      user = create(:user)
      mail = ActionMailer::Base.deliveries.first

      expect(mail).not_to be(nil)
    end

    it "sends confirmation instructions to the user's email" do
      user = create(:user)
      mail = ActionMailer::Base.deliveries.first

      expect([user.email]).to eq(mail.to)
    end
  end
end
