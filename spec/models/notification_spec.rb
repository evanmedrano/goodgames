require 'rails_helper'

describe Notification do
  context "assocations" do
    context "belongs_to" do
      it { should belong_to(:actor).class_name("User").touch(true) }
      it { should belong_to(:notifiable).touch(true) }
      it { should belong_to(:recipient).class_name("User").touch(true) }
    end
  end
end
