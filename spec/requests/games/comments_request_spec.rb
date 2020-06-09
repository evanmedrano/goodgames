require "rails_helper"

describe "Games::Comments" do
  describe "#new" do
    context "when the current game isn't saved in the database" do
      it "persists the game data in order to render comments form" do
        VCR.use_cassette("persists game data before rendering comments form") do
          game = RawgApi::GameService.find("portal-2")

          get new_game_comment_path(game.slug)

          expect(Game.count).to eq(1)
          expect(Game.first.name).to eq("Portal 2")
        end
      end
    end

    context "when the current game is saved in the database" do
      it "loads the game data" do
        VCR.use_cassette("loads game data before rendering comments form") do
          game = create(:game, slug: "portal-2", name: "Portal 2")

          get new_game_comment_path(game.slug)

          expect(Game.count).not_to eq(2)
        end
      end
    end
  end

  describe "#create" do
    context "with valid params" do
      it "creates a new game comment" do
        VCR.use_cassette("creates a new game comment") do
          game = create(:game, slug: "portal-2", name: "Portal 2")
          params = { comment:  { body: "new comment" } }
          sign_in create(:user)

          post game_comments_path(game.slug), params: params

          expect(game.comments.count).to eq(1)
        end
      end

      it "sets game commenter as current user" do
        VCR.use_cassette("sets game commenter as current user") do
          game = create(:game, slug: "portal-2", name: "Portal 2")
          params = { comment:  { body: "new comment" } }
          user = create(:user)
          sign_in user

          post game_comments_path(game.slug), params: params

          expect(user.comments.count).to eq(1)
          expect(Comment.last.user).to eq(user)
        end
      end
    end

    context "with invalid params" do
      it "does not save a new comment" do
        VCR.use_cassette("does not save a new comment") do
          game = create(:game, slug: "portal-2", name: "Portal 2")
          params = { comment:  { body: "" } }
          user = create(:user)
          sign_in user

          post game_comments_path(game.slug), params: params

          expect(game.comments.count).to eq(0)
          expect(user.comments.count).to eq(0)
        end
      end
    end

    context "with a guest user" do
      it "redirects them to log in screen" do
        VCR.use_cassette("does not save a new comment") do
          game = create(:game, slug: "portal-2", name: "Portal 2")
          params = { comment:  { body: "test comment" } }

          post game_comments_path(game.slug), params: params

          expect(response).to redirect_to new_user_session_path
        end

      end
    end
  end
end
