require 'rails_helper'

describe "FriendRequests" do
  describe "#create" do
    context "as a guest user" do
      it "alerts the user that they must sign in first" do
        post friend_requests_path, params: { friend_request: {} }

        expect(flash["alert"]).to include("You need to sign in")
      end
    end

    context "with valid params" do
      it "initiates a job to be performed" do
        user, friend = create(:user), create(:user)
        params = { friend_request: { user_id: user.id, friend_id: friend.id } }
        sign_in user

        post friend_requests_path, params: params

        expect(total_jobs_enqueued).to eq(1)
      end

      it "adds a friend to both the user and friend array" do
        user, friend = create(:user), create(:user)
        params = { friend_request: { user_id: user.id, friend_id: friend.id } }
        sign_in user

        post friend_requests_path, params: params

        expect(user.friends.size).to eq(1)
        expect(friend.friends.size).to eq(1)
      end
    end
  end

  def total_jobs_enqueued
    ActiveJob::Base.queue_adapter.enqueued_jobs.count
  end
end
