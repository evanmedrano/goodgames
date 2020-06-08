require "rails_helper"

describe RawgApi::Platform do
  describe "#games" do
    it "returns games of the current platform" do
      VCR.use_cassette("returns games of the current platform") do
        platform = described_class.new({ id: 4, slug: "pc" })

        expect(platform.games.count).to eq(20)
      end
    end
  end
end
