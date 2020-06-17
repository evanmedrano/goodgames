require 'rails_helper'

describe Message do
  context "assocations" do
    context "belongs_to" do
      it { should belong_to(:recipient).class_name("User").touch(true) }
      it { should belong_to(:sender).class_name("User").touch(true) }
    end
  end

  context "validations" do
    context "presence" do
      it { should validate_presence_of(:body) }
      it { should validate_presence_of(:subject) }
    end
  end
end
