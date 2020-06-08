require 'rails_helper'

describe RawgApi::Request do
  describe "#get" do
    it "displays request header with app information" do
      VCR.use_cassette("displays request header with app information") do
        headers = { "User-Agent" => "GoodGames (+gooooodgames.herokuapp.com)" }
        described_method = RawgApi::Request.get("")

        expect(described_method.request.options[:headers]).to eq(headers)
      end
    end

    it "returns an OK message when successful" do
      VCR.use_cassette("returns an OK message when successful") do
        described_method = RawgApi::Request.get("")

        expect(described_method.response.msg).to eq("OK")
      end
    end

    it "returns a Not Found message when unsuccessful" do
      VCR.use_cassette("returns a Not Found message when unsuccessful") do
        described_method = RawgApi::Request.get("/random-endpoint-here")

        expect(described_method.response.msg).to eq("Not Found")
      end
    end
  end
end
