class ChangeCompleteToDate < ActiveRecord::Migration[5.1]
  def change
    add_column :todos, :complete_date, :date
  end
end
