require 'rails_helper'

describe "Users::CompareGames" do
  describe "#index" do
    it "redirects to the login screen is user is not logged in" do
      user = create(:user)

      get user_compare_games_path(user)

      expect(response).to redirect_to new_user_session_path
    end

    it "returns a 200 response if user is logged in" do
      user = create(:user)

      get user_compare_games_path(user, as: logged_in_user)

      expect(response).to have_http_status(200)
    end
  end
end
