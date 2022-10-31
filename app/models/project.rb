class Project < ApplicationRecord
  belongs_to :user
  has_many :sections, dependent: :destroy
  has_many :tasks, as: :taskable, dependent: :destroy

  validates :title, presence: true

  scope :include_all_tasks, -> { includes(:tasks, sections: :tasks) }

  def as_json(options = {})
    super(
      only: %i[id title],
      include: {
        tasks: {
          only: %i[id title description priority due_date completed]
        },
        sections: {
          include: {
            tasks: {
              only: %i[id title description priority due_date completed]
            }
          },
          only: %i[id title]
        }
      }
    )
  end
end
