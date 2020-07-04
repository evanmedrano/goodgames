require 'rails_helper'

describe "Dashboards" do
  describe "#show" do
    context "when a user is logged in" do
      it "returns http success" do
        get "/dashboard", as: logged_in_user

        expect(response).to have_http_status(:success)
      end
    end

    context "when a user is not logged in" do
      it "redirects to the log in screen" do
        get "/dashboard"

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
