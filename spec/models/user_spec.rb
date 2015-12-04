require 'rails_helper'

RSpec.describe User, :type => :model do
  
    it "has a valid factory" do
       expect(build(:user)).to be_valid
    end

    it "is valid with a firstname, lastname and email" do
	user = build(:user)
        user.valid?
        expect(user).to be_valid
    end


    it "is invalid without a firstname" do
       user = build(:user, first_name: nil)
       user.valid?
       expect(user.errors[:first_name]).to include("can't be blank")
    end


    it "is invalid without a lastname" do
	user = build(:user, last_name: nil)
        user.valid?
        expect(user.errors[:last_name]).to include("can't be blank")
    end


    it "is invalid without an email address" do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with a duplicate email address" do
        create(:user, email: 'duplicate@example.com')
	user = build(:user, email: 'duplicate@example.com')
        user.valid?
        expect(user.errors[:email]).to include("has already been taken")
    end

end
