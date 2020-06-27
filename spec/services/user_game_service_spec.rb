require 'rails_helper'

describe UserGameService do
  include ActiveJob::TestHelper

  describe "#update" do
    context "with valid params" do
      it "updates the objects attribute(s)" do
        user_game = create(:user_game, status: "Playing")
        params = user_game_params(user_game, status: "Owned")
        user_game_service = described_class.new(user_game, params)

        user_game_service.update

        expect(user_game.status).to eq("Owned")
      end

      it "returns true" do
        user_game = create(:user_game)
        params = user_game_params(user_game)
        user_game_service = described_class.new(user_game, params)

        expect(user_game_service.update).to be(true)
      end
    end

    context "with invalid params" do
      it "does not update the objects attribute(s)" do
        user_game = create(:user_game, status: "Playing")
        params = user_game_params(user_game, status: "")
        user_game_service = described_class.new(user_game, params)

        user_game_service.update

        expect(user_game.reload.status).to eq("Playing")
      end

      it "returns false" do
        user_game = create(:user_game)
        params = user_game_params(user_game, status: "")
        user_game_service = described_class.new(user_game, params)

        expect(user_game_service.update).to be(false)
      end
    end

    context "when the status is set to 'Beat'" do
      it "enqueus a job to be performed later" do
        user_game = create(:user_game)
        params = user_game_params(user_game, status: "Beat")
        user_game_service = described_class.new(user_game, params)

        user_game_service.update

        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq(1)
      end
    end
  end

  def user_game_params(user_game, status: "Beat")
    {
      user: user_game.user,
      game: user_game.game,
      status: status,
      platform: "PC"
    }
  end
end
