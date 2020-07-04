require 'rails_helper'

describe "Home" do
  describe "#index" do
    context "when a user is logged in" do
      it "renders their dashboard" do
        get "/", as: logged_in_user

        expect(response).to render_template("dashboards/show")
      end
    end

    context "when a user is not logged in" do
      it "renders the home page" do
        get "/"

        expect(response).to render_template("home/index")
      end
    end
  end
end
