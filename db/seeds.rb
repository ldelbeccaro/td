# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Project.delete_all
RecurringTodo.delete_all
Todo.delete_all

project_1 = Project.create(name: "Main Project")
project_2 = Project.create(name: "Side Project")

recur_1 = RecurringTodo.create(
  text: "recurring daily after completion",
  recurring_type: "after completion",
  recurring_interval_unit: "day",
  recurring_interval_unit_number: 1
)
recur_2 = RecurringTodo.create(
  text: "recurring every 1st and 3rd sunday on schedule",
  recurring_type: "on schedule",
  recurring_interval_unit: "month",
  recurring_interval_unit_number: 1,
  recurring_interval_days: [1],
  recurring_interval_weeks: [1,3]
)
recur_3 = RecurringTodo.create(
  text: "recurring every 2nd thursday on schedule",
  recurring_type: "on schedule",
  recurring_interval_unit: "month",
  recurring_interval_unit_number: 1,
  recurring_interval_days: [5],
  recurring_interval_weeks: [2]
)
recur_4 = RecurringTodo.create(
  text: "recurring every other 2nd of the month on schedule",
  recurring_type: "on schedule",
  recurring_interval_unit: "month",
  recurring_interval_unit_number: 2,
  recurring_interval_days: [2]
)

Todo.create(
  [
    {
      text: "Due today",
      due_date: Date.today,
      project: project_1
    },
    {
      text: "Priority 1",
      priority: 1,
      project: project_1
    },
    {
      text: "Completed",
      completed: true,
      project: project_2
    },
    {
      text: "Deleted",
      due_date: Date.today,
      delete_date: Date.today
    },
    {
      text: "Start today",
      start_date: Date.today
    },
    {
      due_date: Date.yesterday,
      complete_date: Date.today,
      recurring_todo: recur_1
    },
    {
      due_date: Date.today,
      recurring_todo: recur_2,
      project: project_2
    },
    {
      due_date: Date.today,
      recurring_todo: recur_3
    },
    {
      due_date: Date.today,
      recurring_todo: recur_4
    }
  ]
)
