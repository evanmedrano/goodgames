require 'rails_helper'
require 'models/concerns/commentable_spec'

describe Game do
  context "associations" do
    it { should have_many :user_games }
    it { should have_many :users }
    it_behaves_like :commentable
  end

  context "validations" do
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_uniqueness_of(:slug).case_insensitive }
  end
end
