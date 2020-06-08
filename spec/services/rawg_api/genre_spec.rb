require "rails_helper"

describe RawgApi::Genre do
  describe "#games" do
    it "returns games of the current genre" do
      VCR.use_cassette("returns games of the current genre") do
        genre = described_class.new({ slug: "action" })

        expect(genre.games.count).to eq(20)
      end
    end
  end
end
