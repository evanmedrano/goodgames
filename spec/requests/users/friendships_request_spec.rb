require 'rails_helper'

describe "Users::Friendships" do
  describe "#index" do
    it "returns a 200 response if the user is in the database" do
      user = create(:user)

      get user_friendships_path(user)

      expect(response).to have_http_status(200)
    end

    it "renders the error template if the user is not in the database" do
      get user_friendships_path(1)

      expect(response).to render_template("errors/show")
    end
  end
end
