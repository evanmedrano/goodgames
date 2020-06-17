require 'rails_helper'

describe Guest do
  describe "#id" do
    it "returns guest" do
      guest = Guest.new

      expect(guest.id).to eq("guest")
    end
  end

  describe "#first_name" do
    it "returns nil" do
      guest = Guest.new

      expect(guest.first_name).to be(nil)
    end
  end

  describe "#last_name" do
    it "returns nil" do
      guest = Guest.new

      expect(guest.last_name).to be(nil)
    end
  end

  describe "#games" do
    it "returns empty array" do
      guest = Guest.new

      expect(guest.games).to be_empty
    end
  end

  describe "#added_game?" do
    it "returns false" do
      guest = Guest.new

      expect(guest.added_game?("no")).to be(false)
    end
  end

  describe "#has_pending_friendship_with??" do
    it "returns false" do
      guest = Guest.new

      expect(guest.has_pending_friendship_with?("nobody")).to be(false)
    end
  end

  describe "#is_friends_with?" do
    it "returns false" do
      guest = Guest.new

      expect(guest.is_friends_with?("nobody")).to be(false)
    end
  end

  describe "#sent_friend_request_to?" do
    it "returns false" do
      guest = Guest.new

      expect(guest.sent_friend_request_to?("nobody")).to be(false)
    end
  end

  describe "#is_currently_playing_a_game?" do
    it "returns false" do
      guest = Guest.new

      expect(guest.is_currently_playing_a_game?).to be(false)
    end
  end

  describe "#currently_playing" do
    it "returns nil" do
      guest = Guest.new

      expect(guest.currently_playing).to be(nil)
    end
  end

  describe "#can_add_as_a_friend?" do
    it "returns false" do
      guest = Guest.new

      expect(guest.can_add_as_a_friend?("nobody")).to be(false)
    end
  end
end
