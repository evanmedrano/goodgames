require 'rails_helper'

describe MessageService do
  include ::ActiveJob::TestHelper

  describe "#save" do
    context "when the message is valid" do
      it "returns true" do
        message = described_class.new(params)

        expect(message.save).to be(true)
      end

      it "saves a new message in the database" do
        message = described_class.new(params)

        message.save

        expect(Message.count).to eq(1)
      end

      it "starts a new job to send an email" do
        message = described_class.new(params)

        message.save

        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq(1)
      end
    end

    context "when the message is invalid" do
      it "returns false" do
        message = described_class.new(params(body: ""))

        expect(message.save).to be(false)
      end
    end
  end

  def params(body: "Good luck!")
    recipient, sender = create(:user), create(:user)

    {
      body: body,
      recipient_id: recipient.id,
      sender_id: sender.id,
      subject: "Hey!"
    }
  end
end
