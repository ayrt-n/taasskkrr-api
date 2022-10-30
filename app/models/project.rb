class Project < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :tasks, as: :taskable, dependent: :destroy

  validates :title, presence: true

  scope :include_all_tasks, -> { includes(tasks: [:sub_tasks], sections: { tasks: [:sub_tasks] }) }

  def as_json(options = {})
    super(
      only: %i[id title],
      include: {
        tasks: {
          include: {
            sub_tasks: { only: %i[id title description priority due_date completed] }
          },
          only: %i[id title description priority due_date completed]
        },
        sections: {
          include: {
            tasks: {
              include: {
                sub_tasks: { only: %i[id title description priority due_date completed] }
              },
              only: %i[id title description priority due_date completed]
            }
          },
          only: %i[id title]
        }
      }
    )
  end
end
