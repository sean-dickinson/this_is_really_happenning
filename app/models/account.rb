class Account < ApplicationRecord
  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users
  has_many :projects, dependent: :destroy
end
