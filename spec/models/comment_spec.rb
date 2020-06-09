require 'rails_helper'

describe Comment do
  context "associations" do
    it { should belong_to(:commentable).touch(true) }
    it { should belong_to(:user).touch(true) }
  end

  context "validations" do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_most(300) }
    it { should validate_length_of(:title).is_at_most(50) }
  end
end
