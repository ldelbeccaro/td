class Project < ApplicationRecord
  has_many :to_dos

  validates :name, presence: true, uniqueness: true

  scope :all_projects, -> { where(delete_date: nil) }
  # TODO: when projects have parents, this also needs to take into account whether all child projects are complete
  scope :completed, -> { includes(:todos).where(completed: true) }
  # TODO: scope for outstanding projects
end
