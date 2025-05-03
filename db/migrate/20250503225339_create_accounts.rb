class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.timestamps
    end

    create_table :account_user, primary_key: [:account_id, :user_id] do |t|
      t.belongs_to :account
      t.belongs_to :user
      t.timestamps
    end
  end
end
