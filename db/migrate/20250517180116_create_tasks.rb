class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.belongs_to :project, null: false, foreign_key: true
      t.boolean :is_active

      t.timestamps
    end
  end
end
