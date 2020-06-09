require 'rails_helper'

describe Comment do
  context "associations" do
    context "belongs_to" do
      it { should belong_to(:commentable).touch(true) }
      it { should belong_to(:user).touch(true) }
    end
  end

  context "validations" do
    context "length" do
      it { should validate_length_of(:body).is_at_most(300) }
      it { should validate_length_of(:title).is_at_most(50) }
    end

    context "presence" do
      it { should validate_presence_of(:body) }
    end
  end
end
