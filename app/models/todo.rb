class Todo < ApplicationRecord
  scope :outstanding, -> { where(completed: false, delete_date: nil) }
  scope :completed, -> { where(completed: true, delete_date: nil) }
  scope :all_tasks, -> { where(delete_date: nil) }

  def deleted?
    !delete_date.nil?
  end
end
