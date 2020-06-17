require 'rails_helper'

describe "Users::FriendRequests" do
  describe "#index" do
    it "only allows access if the current user is viewing their own messages" do
      user = create(:user)

      get user_friend_requests_path(user_id: user, as: logged_in_user(user))

      expect(response).to have_http_status(200)
    end

    it "redirects logged in users who do not have access to the page" do
      get user_friend_requests_path(user_id: 1, as: logged_in_user)

      expect(response).to redirect_to root_url
    end

    it "redirects guests who do not have access to the page" do
      get user_friend_requests_path(user_id: 1)

      expect(response).to redirect_to new_user_session_path
    end
  end
end
