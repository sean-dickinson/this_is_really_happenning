class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.belongs_to :project, null: false, foreign_key: true
      t.boolean :is_active, null: false, default: false
      t.integer :schedule, null: false
      t.string :uuid, null: false

      t.timestamps
    end
  end
end
