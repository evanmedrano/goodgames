require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "Validations" do
    it { is_expected.to validate_uniqueness_of :name }
  end
  
  describe "Associations" do
    it { is_expected.to have_many :comments }
    it { is_expected.to have_many :user_games }
    it { is_expected.to have_many :users }
  end
end
