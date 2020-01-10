require 'rails_helper'

RSpec.describe GamesController, type: :controller do

    describe "#show" do
        it "responds successfully" do
            game = "portal-2"
            get :show, params: { id: game }
            expect(response).to be_successful
        end

        it "redirects to the home page" do
            game = ""
            get :show, params: { id: game }
            expect(response).to redirect_to root_path
        end
    end

end
