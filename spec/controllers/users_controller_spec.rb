require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #games" do
    it "returns http success" do
      user = FactoryBot.create(:user, id: 1)
      get :games, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

end
