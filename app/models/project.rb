class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :owners, -> { where(project_users: {role: :owner}) }, through: :project_users, source: :user

  validates :owners, length: {minimum: 1}
end
