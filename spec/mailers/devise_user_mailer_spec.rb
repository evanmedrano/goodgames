require "rails_helper"

describe DeviseUserMailer do
  describe "#confirmation_instructions" do
    it "sends an email after a user is created" do
      user = create(:user, :with_confirmation_email)
      mail = ActionMailer::Base.deliveries.first

      expect(mail).not_to be(nil)
    end

    it "sends confirmation instructions to the user's email" do
      user = create(:user, :with_confirmation_email)
      mail = ActionMailer::Base.deliveries.first

      expect([user.email]).to eq(mail.to)
    end
  end
end
