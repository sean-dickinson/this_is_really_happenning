require "rails_helper"

RSpec.describe Project, type: :model do
  it "has a valid factory" do
    expect(build(:valid_project)).to be_valid
  end
end
