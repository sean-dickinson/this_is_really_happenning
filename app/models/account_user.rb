# frozen_string_literal: true

class AccountUser < ApplicationRecord
  self.table_name = "account_user"

  belongs_to :account
  belongs_to :user
end
