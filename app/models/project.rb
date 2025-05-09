class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users

  # TODO: require at least 1 project user with the role of "owner"
  validates :project_users, length: { minimum: 1 }
end
