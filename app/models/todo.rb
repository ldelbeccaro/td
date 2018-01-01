class Todo < ApplicationRecord
  # TODO: tests
  include RecurringHelper

  belongs_to :project, optional: true
  belongs_to :recurring_todo, optional: true

  validate :recurring_options_valid

  after_commit :check_to_add_recurring_info
  after_commit :check_to_add_recurring_todos

  scope :outstanding, -> { where(completed: false, delete_date: nil) }
  scope :completed, -> { where(completed: true, delete_date: nil) }
  scope :all_todos, -> { where(delete_date: nil) }

  def deleted?
    delete_date.present?
  end

  def recurring?
    recurring_todo.present?
  end

  def completed?
    complete_date.present?
  end

  def should_add_recurring_todo
    satisfies_completion = true
    if recurring_todo.recurring_type == "after completion"
      satisfies_completion = complete_date.present?
    end
    return satisfies_completion && Todo.where(recurring_todo: recurring_todo, complete_date: nil).empty?
  end

  def check_to_add_recurring_info
    if text.nil?
      self.text = recurring_todo.text
      self.save
    end
  end

  def check_to_add_recurring_todos
    # TODO: run this every night
    return if deleted? or !recurring? or !should_add_recurring_todo()

    next_due_date = next_recurring_todo_date(self)
    return if next_due_date.nil?

    # TODO: use a job for this
    new_todo = Todo.create! ({
      due_date: next_due_date,
      project: project,
      priority: priority,
      recurring_todo: recurring_todo,
      text: recurring_todo.text
    })
  end

  def recurring_options_valid
    if recurring_todo.present?
      if due_date.nil?
        errors.add(:due_date, "due date required for on schedule recurring todos")
      end
    end
  end
end
