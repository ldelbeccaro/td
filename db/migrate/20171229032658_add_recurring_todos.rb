class AddRecurringTodos < ActiveRecord::Migration[5.1]
  def change
    create_table :recurring_todos do |t|
      t.string :text, null: false
      # recurring_type:
        # "after completion" (clean your room 2 weeks after you did it the last time)
        # "on schedule" (if you missed yesterday's, you have to do both yesterday's and today's. you could possibly do tomorrow's.)
      t.string :recurring_type, default: "on schedule"
      # recurring_interval_unit: day, week, month or year
      t.string :recurring_interval_unit, default: "day"
      # recurring_interval_unit_number:
        # 1 (every 1 day)
        # 3 (every 3 months)
      t.integer :recurring_interval_unit_number, default: 1
      # recurring_interval_days:
        # [1, 2] (every sunday, monday of a week)
        # [1, 2] (every 1st and 2nd of a month)
        # [4] (every 3nd wednesday of a month - requires recurring_interval_week as well)
      t.integer :recurring_interval_days, array: true
      # recurring_interval_weeks:
        # [3] (every 3rd tuesday of a month - requires recurring_interval_days as well)
        # [1, 3] (every 1st and 3rd friday of a month - requires recurring_interval_days as well)
      t.integer :recurring_interval_weeks, array: true
      t.date :delete_date

      t.timestamps
    end

    add_reference :todos, :recurring_todo
  end
end

# cases to consider:

# every X days, weeks, months, years
# every X, X day of week
# every X, X day of month
# every X date of month every X months
# monthly on X date
# monthly on X weekday of month
# every X date of year

# example form:

# "every <recurring_interval_unit_number> <recurring_interval_unit>""
# then checkbox <recurring_type>
# then *only if recurring_type == "on schedule"*:
  # if unit is day, nothing happens
  # if unit is week, show "on <recurring_interval_days>" (with options mon, tues, wed)
  # if unit is month, show
    # 1. "on specific date(s): <recurring_interval_days>"
    # OR
    # 2. "on <recurring_interval_weeks><st,nd,rd,th> (with multiple options) <recurring_interval_days> (with options mon, tues, wed)"
  # if unit is year, show "on specific date: <due_date>"
