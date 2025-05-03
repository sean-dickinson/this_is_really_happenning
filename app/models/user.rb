class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :accounts, length: {minimum: 1}
  validates :email_address, presence: true, uniqueness: {case_sensitive: false}
end
