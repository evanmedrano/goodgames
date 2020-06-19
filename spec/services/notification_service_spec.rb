require 'rails_helper'

describe NotificationService do
  describe "#save" do
    context "when the notification is valid" do
      it "returns true" do
        notification = described_class.new(params)

        expect(notification.save).to be(true)
      end

      it "saves a new notification in the database" do
        notification = described_class.new(params)

        notification.save

        expect(Notification.count).to eq(1)
      end
    end

    context "when the notification is invalid" do
      it "returns false" do
        notification = described_class.new(params(action: ""))

        expect(notification.save).to be(false)
      end
    end
  end

  def params(recipient_id: create(:user).id, action: "sent")
    actor = create(:user)
    notifiable = create(:message)

    {
      actor_id: actor.id,
      action: action,
      notifiable: notifiable,
      recipient_id: recipient_id,
    }
  end
end
