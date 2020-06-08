require "rails_helper"

describe "Games" do
  describe "#index" do
    context "without a query" do
      it "responds successfully" do
        VCR.use_cassette("renders a list of games without a query") do
          get games_path

          expect(response).to be_successful
        end
      end
    end

    context "with a successful query" do
      it "responds successfully" do
        VCR.use_cassette("renders searched for game and/or simliar games") do
          get games_path(params: { query: "Super smash bros" })

          expect(response).to be_successful
        end
      end
    end

    context "with an unsuccssful query" do
      it "returns an alert saying game is not in database" do
        VCR.use_cassette("returns an alert saying game is not in database") do
          get games_path(params: { query: "randomunsuccessfulquery" })

          expect(flash[:alert]).to include("that game isn't in our database.")
        end
      end

      it "redirects user to games index" do
        VCR.use_cassette("redirects user to index for invalid query") do
          get games_path(params: { query: "randomunsuccessfulquery" })

          expect(response).to redirect_to games_path
        end
      end
    end
  end

  describe "#show" do
    context "with valid params" do
      it "returns a successful response with game data" do
        VCR.use_cassette("returns a successful response with game data") do
          get game_path("portal-2")

          expect(response).to be_successful
        end
      end
    end

    context "with invalid params" do
      it "returns an alert saying game is not in database" do
        VCR.use_cassette("show returns alert saying game isn't in database") do
          get game_path("random-game-slug")

          expect(flash[:alert]).to include("that game isn't in our database.")
        end
      end

      it "redirects user to games index" do
        VCR.use_cassette("redirects user to index for invalid show params") do
          get game_path("random-game-slug")

          expect(response).to redirect_to games_path
        end
      end
    end
  end

  describe "#create" do
    context "with valid params" do
      it "adds game to user's games list" do
        VCR.use_cassette("adds game to user's games list") do
          game_params = { game: { slug: "portal-2" } }
          user = create(:user)
          sign_in user

          post games_path, params: game_params

          expect(user.games.count).to eq(1)
          expect(user.games.first.name).to eq("Portal 2")
        end
      end

      context "when game is not already in database" do
        it "persists game data to database" do
          VCR.use_cassette("persists game data to database") do
            sign_in create(:user)

            post games_path, params: { game: { slug: "portal-2" } }

            expect(Game.count).to eq(1)
            expect(Game.first.name).to eq("Portal 2")
          end
        end
      end

      context "when game is already in database" do
        it "does not persist game data to database" do
          VCR.use_cassette("does not persist game data to database") do
            create(:game, slug: "portal-2", name: "Portal 2")
            sign_in create(:user)

            post games_path, params: { game: { slug: "portal-2" } }

            expect(Game.count).not_to eq(2)
          end
        end
      end
    end

    context "with invalid params" do
      it "does not persist invalid params to database" do
        VCR.use_cassette("does not persist invalid params to database") do
          sign_in create(:user)

          post games_path, params: { game: { slug: "" } }

          expect(Game.count).to eq(0)
        end
      end

      it "returns an alert saying there was an error" do
        VCR.use_cassette("show returns alert saying there was an error") do
          sign_in create(:user)

          post games_path, params: { game: { slug: "" } }

          expect(flash[:alert]).to include("There was an error adding the game")
        end
      end
    end

    context "when a user is not signed in" do
      it "redirects user to log in screen" do
        VCR.use_cassette("redirects user to log in screen") do
          post games_path, params: { game: { slug: "portal-2" } }

          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
