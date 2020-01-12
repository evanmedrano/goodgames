require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #games" do
    it "returns http success" do
      get :games
      expect(response).to have_http_status(:success)
    end
  end

end
