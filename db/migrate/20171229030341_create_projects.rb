class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.date :start_date
      t.date :due_date
      t.integer :priority
      t.date :delete_date

      t.timestamps
    end
  end
end
