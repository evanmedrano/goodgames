require 'rails_helper'

RSpec.describe GamesController, type: :controller do

    describe "GET #show" do
        it "responds successfully" do
            game = "portal-2"
            get :show, params: { id: game }
            expect(response).to be_successful
        end

        it "redirects to the games index page" do
          skip
            game = "This is an incorrect game slug"
            get :show, params: { id: game }
            expect(response).to redirect_to games_path
        end
        
    end

end
