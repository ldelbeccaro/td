class ChangeTodoColumns < ActiveRecord::Migration[5.1]
  def change
    change_column :todos, :due_date, 'date using due_date::date'

    allow_null_values = true
    change_column_null :todos, :text, allow_null_values
  end
end
