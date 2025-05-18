class CreateCheckIns < ActiveRecord::Migration[8.0]
  def change
    create_table :check_ins do |t|
      t.belongs_to :task, null: false, foreign_key: true
      t.json :metadata

      t.timestamps
    end
  end
end
