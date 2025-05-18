class Task < ApplicationRecord
  belongs_to :project
  enum :schedule, {hourly: 0, daily: 1, weekly: 2, monthly: 3}, validate: true

  attribute :uuid, :string, default: -> { SecureRandom.uuid }

  validates :name, presence: true
  validates :schedule, presence: true
  validates :uuid, presence: true
end
