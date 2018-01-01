# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171229202931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.date "start_date"
    t.date "due_date"
    t.integer "priority"
    t.date "delete_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recurring_todos", force: :cascade do |t|
    t.string "text", null: false
    t.string "recurring_type", default: "on schedule"
    t.string "recurring_interval_unit", default: "day"
    t.integer "recurring_interval_unit_number", default: 1
    t.integer "recurring_interval_days", array: true
    t.integer "recurring_interval_weeks", array: true
    t.date "delete_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "todos", force: :cascade do |t|
    t.date "start_date"
    t.date "due_date"
    t.integer "priority"
    t.text "text"
    t.boolean "completed", default: false
    t.date "delete_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.bigint "recurring_todo_id"
    t.date "complete_date"
    t.index ["project_id"], name: "index_todos_on_project_id"
    t.index ["recurring_todo_id"], name: "index_todos_on_recurring_todo_id"
  end

end
