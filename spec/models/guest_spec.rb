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
end
