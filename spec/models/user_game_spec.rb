require 'rails_helper'

describe UserGame do
  context "associations" do
    context "belongs_to" do
      it { should belong_to(:game).touch(true) }
      it { should belong_to(:user).touch(true) }
    end
  end

  context "validations" do
    context "inclusion" do
      it do
        should validate_inclusion_of(:status).
          in_array(%w[Currently\ own Owned Beat Playing Wishlist])
      end
    end

    context "presence" do
      it { should validate_presence_of(:status) }
    end

    context "uniqueness" do
      it do
        create(:user_game)
        should validate_uniqueness_of(:user).scoped_to(:game_id)
      end
    end
  end
end
