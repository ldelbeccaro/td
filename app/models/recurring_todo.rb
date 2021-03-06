class RecurringTodo < ApplicationRecord
  # TODO: tests

  has_many :todos

  validates :text, presence: true
  validates :recurring_type, inclusion: { in: ['on schedule', 'after completion'] }, presence: true
  validates :recurring_interval_unit, inclusion: { in: %w[day week month year] }, presence: true
  validates :recurring_interval_unit_number, numericality: { greater_than: 0 }, presence: true
  validate :valid_recurring_options

  def valid_recurring_options
    non_weekdays = recurring_interval_days.nil? || recurring_interval_days.any? { |num| !num.is_a? Integer || num < 1 || num > 7 }
    non_month_days = recurring_interval_days.nil? || recurring_interval_days.any? { |num| !num.is_a? Integer || num < 1 || num > 31 }

    if recurring_interval_unit == 'month' && recurring_interval_weeks.present?
      non_weeks = recurring_interval_weeks.any? { |num| !num.is_a? Integer || num < 1 || num > 5 }
      if non_weeks
        errors.add(:recurring_interval_weeks, 'must be weeks between 1 and 5')
      elsif non_weekdays
        errors.add(:recurring_interval_days, 'must be weekdays between 1 and 7')
      end
    elsif recurring_interval_weeks.nil?
      if recurring_interval_unit == 'week' && non_weekdays
        errors.add(:recurring_interval_days, 'must be weekdays between 1 and 7')
      elsif recurring_interval_unit == 'month' && non_month_days
        errors.add(:recurring_interval_days, 'must be a valid date between 1 and 31')
      end
    end
  end
end

# SPEC

# recurring_type:
#   t.string :recurring_type, default: 'on schedule'
#   'after completion' (clean your room 2 weeks after you did it the last time)
#   'on schedule' (if you missed yesterday's, you have to do both yesterday's and today's. you could possibly do tomorrow's.)
# recurring_interval_unit: day, week, month or year
#   t.string :recurring_interval_unit, default: 'day'
# recurring_interval_unit_number:
#   t.integer :recurring_interval_unit_number, default: 1
#   1 (every 1 day)
#   3 (every 3 months)
# recurring_interval_days:
#   t.integer :recurring_interval_days, array: true
#   [1, 2] (every sunday, monday of a week)
#   [1, 2] (every 1st and 2nd of a month)
#   [4] (every 3nd wednesday of a month - requires recurring_interval_weeks as well)
# recurring_interval_weeks:
#   t.integer :recurring_interval_weeks, array: true
#   [3] (every 3rd tuesday of a month - requires recurring_interval_days as well)
#   [1, 3] (every 1st and 3rd friday of a month - requires recurring_interval_days as well)

# cases to consider:

# every X days, weeks, months, years
# every X, X day of week
# every X, X day of month
# every X date of month every X months
# monthly on X date
# monthly on X weekday of month
# every X date of year

# example form:

# 'every <recurring_interval_unit_number> <recurring_interval_unit>''
# then checkbox <recurring_type>
# then *only if recurring_type == 'on schedule'*:
#   if unit is day, nothing happens
#   if unit is week, show 'on <recurring_interval_days>' (with options mon, tues, wed)
#   if unit is month, show
#     1. 'on specific date(s): <recurring_interval_days>'
#     OR
#     2. 'on <recurring_interval_weeks><st,nd,rd,th> (with multiple options) <recurring_interval_days> (with options mon, tues, wed)'
#   if unit is year, show 'on specific date: <due_date>'
