require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with a unique email address" do
      user1 = create(:user)
      user2 = build(:user, email_address: user1.email_address)

      expect(user2).not_to be_valid
      expect(user2.errors).to have_key :email_address
    end
  end
end
