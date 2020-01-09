require 'rails_helper'

RSpec.describe User, type: :model do
  
    describe "Validations" do
        it "is valid with a name, email, and password" do
            user = FactoryBot.create(:user)

            expect(user).to be_valid
        end

        it "is invalid without a name" do
            user = FactoryBot.build(:user, name: nil)

            user.valid?
            expect(user.errors.messages[:name]).to include "can't be blank"
        end

        it "is invalid without an email" do
            user = FactoryBot.build(:user, email: nil)

            user.valid?
            expect(user.errors.messages[:email]).to include "can't be blank"
        end

        it "is invalid without a password" do
            user = FactoryBot.build(:user, password: nil)

            user.valid?
            expect(user.errors.messages[:password]).to include "can't be blank"
        end

        it "is invalid if email is already taken" do
            user       = FactoryBot.create(:user)
            other_user = FactoryBot.build(:user, email: user.email)

            other_user.valid?
            expect(other_user.errors.messages[:email]).to include "has already been taken"
        end
        
    end
end
