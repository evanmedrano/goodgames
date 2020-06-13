require 'rails_helper'

describe FriendRequestJob do
  describe "#perform_later" do
    it "adds a job to the queue" do
      ActiveJob::Base.queue_adapter = :test
      user, friend = create(:user), create(:user)

      expect {
        described_class.perform_later(user_id: user.id, friend_id: friend.id)
      }.to have_enqueued_job
    end
  end
end
