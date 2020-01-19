require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  describe "Validations" do
    it "is valid with a user, game, title, and body" do
      comment = FactoryBot.build_stubbed(:comment)

      expect(comment).to be_valid
    end

    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :game }

  end

  describe "Associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :game }
  end

end
