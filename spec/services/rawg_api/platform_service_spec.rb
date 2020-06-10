require "rails_helper"

describe RawgApi::PlatformService do
  describe ".all" do
    it "returns all of the platforms from the api call" do
      VCR.use_cassette("returns all of the platforms from the api call") do
        response = described_class.all

        expect(response.count).to eq(50)
        expect(response.first.name).to eq("PC")
      end
    end
  end

  describe ".find" do
    context "with a valid platform" do
      it "returns the correct platform data" do
        VCR.use_cassette("returns the correct platform data") do
          response = described_class.find("pc")

          expect(response.name).to eq("PC")
        end
      end
    end

    context "with an invalid platform" do
      it "returns no platform data" do
        VCR.use_cassette("returns no platform data") do
          response = described_class.find("")

          expect(response.name).to eq(nil)
        end
      end
    end
  end
end
