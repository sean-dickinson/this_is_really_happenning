class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.timestamps
    end

    create_table :project_users, primary_key: [:user_id, :project_id] do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.string :role
      t.timestamps
    end
  end
end
