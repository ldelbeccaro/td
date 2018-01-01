module RecurringHelper

  def weekdays(array)
    raise 'Invalid weekday' if array.any? { |weekday_num| !weekday_num.is_a? Integer or weekday_num < 1 or weekday_num > 7 }
    days_of_week = [
      '0-index',
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday'
    ]
    array.map { |weekday_num| days_of_week[weekday_num] }
  end

  def month(month_num)
    raise 'Invalid month' if !month_num.is_a? Integer or month_num < 1 or month_num > 12
    months = [
      '0-index',
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december'
    ]
    months[month_num]
  end

  def ordinals(array)
    array.map do |num|
      last_number = num.to_s[-1]
      if last_number == '3' && num.to_s[-2..-1] != '13'
        ordinal = 'rd'
      elsif last_number == '2' && num.to_s[-2..-1] != '12'
        ordinal = 'nd'
      elsif last_number == '1' && num.to_s[-2..-1] != '11'
        ordinal = 'st'
      else
        ordinal = 'th'
      end
      num.to_s + ordinal
    end
  end

  def add_and(array)
    num = array.length
    if num == 1
      array[0].to_s
    elsif num == 2
      array.join(' and ')
    elsif num > 2
      array[0..-2].join(', ') + ' and ' + array[-1].to_s
    end
  end

  def recurring_unit_text(todo)
    recurring_todo = todo.recurring_todo
    if recurring_todo.recurring_interval_unit_number == 1
      "every #{recurring_todo.recurring_interval_unit}"
    else
      "every #{recurring_todo.recurring_interval_unit_number} #{recurring_todo.recurring_interval_unit}s"
    end
  end

  def recurring_date_text(todo)
    recurring_todo = todo.recurring_todo
    if recurring_todo.recurring_type == 'after completion'
      ' after completion'
    elsif recurring_todo.recurring_interval_unit == 'year'
      " on #{month(todo.due_date.month)} #{add_and(ordinals([todo.due_date.day]))}"
    elsif recurring_todo.recurring_interval_unit == 'month'
      if recurring_todo.recurring_interval_weeks.present?
        " on the #{add_and(ordinals(recurring_todo.recurring_interval_weeks))} #{add_and(weekdays(recurring_todo.recurring_interval_days))} of the month"
      else
        " on the #{add_and(ordinals(recurring_todo.recurring_interval_days))} of the month"
      end
    elsif recurring_todo.recurring_interval_unit == 'week'
      " on #{add_and(weekdays(recurring_todo.recurring_interval_days))}"
    elsif recurring_todo.recurring_interval_unit == 'day'
      ''
    end
  end

  def recurring_text(todo)
    return if todo.deleted? || !todo.recurring?
    recurring_unit_text(todo) + recurring_date_text(todo)
  end

  def recurring_reference_date(todo)
    if todo.recurring_todo.recurring_type == 'on schedule'
      todo.due_date
    else
      todo.complete_date
    end
  end

  def next_unit_in_array(current_unit, array)
    units = array[0..-1]
    units = units.push(current_unit).uniq.sort()
    next_in_array = units.index(current_unit) + 1
    # return first in array if at end
    units[next_in_array] || array[0]
  end

  def first_of_month(date)
    Date.new(date.year, date.month, 1)
  end

  def get_next_X_weekday(date, weekday)
    wday_diff = weekday - (date.wday + 1)
    if wday_diff < 0
      wday_diff += 7
    end
    date + wday_diff.day
  end

  def first_weekday_of_month(date, weekday)
    get_next_X_weekday(first_of_month(date), weekday)
  end

  def next_recurring_todo_date(todo)
    return if todo.deleted? or !todo.recurring?
    return if todo.recurring_todo.recurring_type == 'after completion' and !todo.completed?

    date = recurring_reference_date(todo)
    recurring_todo = todo.recurring_todo

    if recurring_todo.recurring_interval_unit == 'year'
      return date + recurring_todo.recurring_interval_unit_number.year
    elsif recurring_todo.recurring_interval_unit == 'month'
      if recurring_todo.recurring_interval_weeks.present?
        # TODO: clean up this logic more.....
        # TODO: handle if this date (e.g., 4th X in Feb) doesn't exist
          # currently just waiting for the next 4th X (in March, in this example)
        weekday = date.wday + 1
        next_weekday = next_unit_in_array(weekday, recurring_todo.recurring_interval_days)

        # check if we're already in the right week and should return the next weekday in that week
        next_weekday_date = get_next_X_weekday(date, next_weekday)
        week = next_weekday_date.cweek - first_weekday_of_month(date, next_weekday).cweek + 1
        if recurring_todo.recurring_interval_weeks.include?(week)
          return next_weekday_date
        end

        # not currently in a returnable week
        # starting in a fresh week, start at beginning of week
        new_next_weekday = recurring_todo.recurring_interval_days.sort()[0]
        if new_next_weekday != next_weekday
          # reset
          next_weekday_date = get_next_X_weekday(date, new_next_weekday)
          week = next_weekday_date.cweek - first_weekday_of_month(date, next_weekday).cweek + 1
        end

        next_week = next_unit_in_array(week, recurring_todo.recurring_interval_weeks)
        week_diff = next_week - week
        if week_diff >= 0 && (next_weekday_date + week_diff.week).month == next_weekday_date.month
          # we're in the right month and can add 
          return next_weekday_date + week_diff.week
        else
          if week_diff > 0
            # == 0 case should never happen, because next_weekday_date + week_diff.week should == next_weekday_date
            # starting in a new month, reset
            next_week = recurring_todo.recurring_interval_weeks.sort()[0]
          end
          first_of_correct_month = first_of_month(date) + (recurring_todo.recurring_interval_unit_number).month
          next_weekday_date = get_next_X_weekday(first_of_correct_month, new_next_weekday)
          return next_weekday_date + (next_week - 1).week
        end

      else
        day = date.day
        next_day = next_unit_in_array(day, recurring_todo.recurring_interval_days)

        # determine whether to go into the next (or later) month
        month = 0
        if next_day < day
          month = recurring_todo.recurring_interval_unit_number
        end

        return first_of_month(date) + month.month + (next_day - 1).day
      end
    elsif recurring_todo.recurring_interval_unit == 'week'
      weekday = date.wday + 1
      next_weekday = next_unit_in_array(weekday, recurring_todo.recurring_interval_days)

      # determine whether to go into the next (or later) week
      if next_weekday <= weekday
        next_weekday += recurring_todo.recurring_interval_unit_number * 7
      end

      return date + (next_weekday - weekday).day
    elsif recurring_todo.recurring_interval_unit == 'day'
      return date + (recurring_todo.recurring_interval_unit_number).day
    else
      raise 'Invalid recurring interval unit'
    end
  end

end
