# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Todo.delete_all

Todo.create! (
  [
    {
      text: "Due today",
      due_date: Date.today
    },
    {
      text: "Priority 1",
      priority: 1
    },
    {
      text: "Completed",
      completed: true
    },
    {
      text: "Deleted",
      delete_date: Date.today
    },
    {
      text: "Start today",
      start_date: Date.today
    }
  ]
)
