require "rails_helper"

describe "Genres" do
  describe "#index" do
    it "responds successfully" do
      VCR.use_cassette("renders a list of genres") do
        get genres_path

        expect(response).to be_successful
      end
    end
  end

  describe "#show" do
    context "with valid params" do
      it "returns a successful response with genre data" do
        VCR.use_cassette("returns a successful response with genre data") do
          get genre_path("action")

          expect(response).to be_successful
        end
      end
    end

    context "with invalid params" do
      it "returns an alert saying genre could not be found" do
        VCR.use_cassette("returns alert saying genre could not be found") do
          get genre_path("random-genre-slug")

          expect(flash[:alert]).to include("could not find the genre.")
        end
      end

      it "redirects user to genres index" do
        VCR.use_cassette("redirects user to index for invalid genre params") do
          get genre_path("random-genre-slug")

          expect(response).to redirect_to genres_path
        end
      end
    end
  end
end
