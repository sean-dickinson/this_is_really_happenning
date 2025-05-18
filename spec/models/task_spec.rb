require "rails_helper"

RSpec.describe Task, type: :model do
  describe "validations" do
    it "validates presence of name" do
      task = Task.new(name: nil)
      expect(task).not_to be_valid
      expect(task.errors).to have_key(:name)
    end
    it "validates presence of schedule" do
      task = Task.new(schedule: nil)
      expect(task).not_to be_valid
      expect(task.errors).to have_key(:schedule)
    end

    it "validates schedule is in the enum" do
      task = Task.new(schedule: "invalid_schedule")
      expect(task).not_to be_valid
      expect(task.errors).to have_key(:schedule)
    end

    it "validates presence of uuid" do
      task = Task.new(uuid: nil)
      expect(task).not_to be_valid
      expect(task.errors).to have_key(:uuid)
    end
  end

  it "set a default value for uuid" do
    task = Task.new
    expect(task.uuid).to be_present
  end

  it "has a valid factory" do
    task = build(:task)
    expect(task).to be_valid
  end
end
