class Task < ApplicationRecord
  has_many :sub_tasks, as: :taskable, class_name: 'Task'
  belongs_to :taskable, polymorphic: true

  validates :title, presence: true
  validate :not_nested_sub_sub_tasks

  private

  def not_nested_sub_sub_tasks
    return unless taskable_type == 'Task' && taskable.taskable_type == 'Task'

    errors.add(:task, "can't be nested within a sub-task")
  end
end
