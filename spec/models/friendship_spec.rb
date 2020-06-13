require 'rails_helper'

describe Friendship do
  context "associations" do
    context "belongs_to" do
      it { should belong_to(:user).touch(true) }
      it { should belong_to(:friend).class_name("User").touch(true) }
    end
  end

  context "validations" do
    context "uniqueness" do
      it do
        create(:friendship)
        should validate_uniqueness_of(:user).scoped_to(:friend_id)
      end
    end
  end
end
