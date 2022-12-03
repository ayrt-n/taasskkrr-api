class Task < ApplicationRecord
  belongs_to :project
  belongs_to :section, optional: true

  validates :title, presence: true

  delegate :user, to: :project

  def as_json(_options = {})
    super(
      only: %i[id title description priority due_date status project_id section_id]
    )
  end
end
