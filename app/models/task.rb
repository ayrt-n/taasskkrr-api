class Task < ApplicationRecord
  belongs_to :taskable, polymorphic: true
  belongs_to :user

  validates :title, presence: true

  def as_json(_options = {})
    super(
      only: %i[id title description priority due_date status]
    )
  end
end
