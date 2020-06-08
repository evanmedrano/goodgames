require "rails_helper"

describe RawgApi::GenreService do
  describe ".all" do
    it "returns all of the genres from the api call" do
      VCR.use_cassette("returns all of the genres from the api call") do
        response = described_class.all

        expect(response.count).to eq(19)
        expect(response.first.name).to eq("Action")
      end
    end
  end

  describe ".find" do
    context "with a valid genre" do
      it "returns the correct genre data" do
        VCR.use_cassette("returns the correct genre data") do
          response = described_class.find("action")

          expect(response.name).to eq("Action")
        end
      end
    end

    context "with an invalid genre" do
      it "returns no genre data" do
        VCR.use_cassette("returns no genre data") do
          response = described_class.find("")

          expect(response.name).to eq(nil)
        end
      end
    end
  end
end
