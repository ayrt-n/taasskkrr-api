class Project < ApplicationRecord
  belongs_to :user
  has_many :sections, dependent: :delete_all
  has_many :tasks, dependent: :delete_all
  has_many :project_tasks, -> { where section_id: nil }, class_name: 'Task'

  validates :title, presence: true

  scope :include_all_tasks, -> { includes(:project_tasks, sections: :tasks) }

  def as_json(options = {})
    # Set options :only as default if not supplied
    options[:only] = %i[id title inbox] unless options[:only]

    # Rename 'project_tasks' key to just be 'tasks'
    super(options).tap { |hash| hash['tasks'] = hash.delete('project_tasks') }
  end
end
