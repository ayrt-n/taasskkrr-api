class Task < ApplicationRecord
  has_many :sub_tasks, as: :taskable, class_name: 'Task'
end
