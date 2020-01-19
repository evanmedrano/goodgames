require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe "Validations" do
    it "is valid with a name, email, and password" do
      user = FactoryBot.build_stubbed(:user)

      expect(user).to be_valid
    end

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    
  end

  describe "Associations" do
    it { is_expected.to have_many :comments }
    it { is_expected.to have_many :user_games }
    it { is_expected.to have_many :games }
  end
end
