class CreateTodos < ActiveRecord::Migration[5.1]
  def change
    create_table :todos do |t|
      t.date :start_date
      t.string :due_date
      t.integer :priority
      t.text :text
      t.boolean :completed, default: false
      t.date :delete_date

      t.timestamps
    end
  end
end
