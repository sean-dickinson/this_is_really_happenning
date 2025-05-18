class Task < ApplicationRecord
  belongs_to :project
  has_many :check_ins, dependent: :destroy
  has_one :last_check_in, -> { order(created_at: :desc) }, class_name: "CheckIn"

  enum :schedule, {hourly: 0, daily: 1, weekly: 2, monthly: 3}, validate: true

  attribute :uuid, :string, default: -> { SecureRandom.uuid }

  validates :name, presence: true
  validates :schedule, presence: true
  validates :uuid, presence: true
end
