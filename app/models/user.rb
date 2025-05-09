class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: {case_sensitive: false}
end
