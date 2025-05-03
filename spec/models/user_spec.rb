require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is not valid if no account" do
      user = build(:user, accounts: [])

      expect(user).not_to be_valid
      expect(user.errors).to have_key :accounts
    end

    it "is valid with at least 1 account" do
      user = build(:user, accounts: [build(:account)])

      expect(user.accounts).not_to be_empty
      expect(user).to be_valid
    end

    it "is valid with a unique email address" do
      user1 = create(:user)
      user2 = build(:user, email_address: user1.email_address)

      expect(user2).not_to be_valid
      expect(user2.errors).to have_key :email_address
    end
  end
end
