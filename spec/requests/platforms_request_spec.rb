require "rails_helper"

describe "Platforms" do
  describe "#index" do
    it "responds successfully" do
      VCR.use_cassette("renders a list of platforms") do
        get platforms_path

        expect(response).to be_successful
      end
    end
  end

  describe "#show" do
    context "with valid params" do
      it "returns a successful response with platform data" do
        VCR.use_cassette("returns a successful response with platform data") do
          get platform_path("pc")

          expect(response).to be_successful
        end
      end
    end

    context "with invalid params" do
      it "returns an alert saying platform could not be found" do
        VCR.use_cassette("returns alert saying platform could not be found") do
          get platform_path("random-platform-slug")

          expect(flash[:alert]).to include("could not find the platform.")
        end
      end

      it "redirects user to platforms index" do
        VCR.use_cassette("redirects user for invalid platform params") do
          get platform_path("random-platform-slug")

          expect(response).to redirect_to platforms_path
        end
      end
    end
  end
end
