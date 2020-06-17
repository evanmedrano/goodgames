require 'rails_helper'

describe "Users::Messages::Inboxes" do
  describe "#index" do
    it "only allows access if the current user is viewing their own messages" do
      user = create(:user)

      get user_inbox_index_path(user_id: user, as: logged_in_user(user))

      expect(response).to have_http_status(200)
    end

    it "redirects logged in users who do not have access to the page" do
      user = create(:user)

      get user_inbox_index_path(user_id: user, as: logged_in_user)

      expect(response).to redirect_to root_url
    end

    it "redirects guests who do not have access to the page" do
      user = create(:user)

      get user_inbox_index_path(user_id: user)

      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "#show" do
    it "allows access if the current user is viewing their own messages" do
      user = create(:user)
      message = create(:message, recipient: user)

      get user_inbox_path(
        user_id: user.id, id: message.id, as: logged_in_user(user)
      )

      expect(response).to have_http_status(200)
    end

    it "redirects logged in users who do not have access to the page" do
      user = create(:user)

      get user_inbox_path(user_id: user, id: 1, as: logged_in_user)

      expect(response).to redirect_to root_url
    end

    it "redirects guests who do not have access to the page" do
      user = create(:user)

      get user_inbox_path(user_id: user, id: 1)

      expect(response).to redirect_to new_user_session_path
    end
  end

end
