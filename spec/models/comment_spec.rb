require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  describe "Validations" do
    it "is valid with a user, game, title, and body" do
      comment = FactoryBot.build_stubbed(:comment)

      expect(comment.valid?).to eq true
    end

    it "is invalid without a title" do
      comment = FactoryBot.build_stubbed(:comment, title: nil)
      comment.valid?

      expect(comment.errors.messages[:title]).to include("can't be blank")
    end

    it "is invalid without a body" do
      comment = FactoryBot.build_stubbed(:comment, body: nil)
      comment.valid?

      expect(comment.errors.messages[:body]).to include("can't be blank")
    end

    it "is invalid without a user" do
      comment = FactoryBot.build_stubbed(:comment, user: nil)
      comment.valid?

      expect(comment.errors.messages[:user]).to include("can't be blank")
    end

    it "is invalid without a game" do
      comment = FactoryBot.build_stubbed(:comment, body: nil)
      comment.valid?

      expect(comment.errors.messages[:body]).to include("can't be blank")
    end
  end

end
