class Project < ApplicationRecord
  belongs_to :user
  has_many :sections, dependent: :destroy
  has_many :tasks, as: :taskable, dependent: :destroy

  validates :title, presence: true

  scope :include_all_tasks, -> { includes(:tasks, sections: :tasks) }

  def as_json(_options = {})
    super(
      only: %i[id title inbox],
      include: {
        tasks: {
          only: %i[id title description priority due_date status]
        },
        sections: {
          include: {
            tasks: {
              only: %i[id title description priority due_date status]
            }
          },
          only: %i[id title]
        }
      }
    )
  end
end
