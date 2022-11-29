class Project < ApplicationRecord
  belongs_to :user
  has_many :sections, dependent: :destroy
  has_many :tasks, as: :taskable, dependent: :destroy

  validates :title, presence: true

  scope :include_all_tasks, -> { includes(:tasks, sections: :tasks) }

  def as_json(options = {})
    options[:only] = %i[id title inbox] unless options[:only]
    super(options)
  end
end
