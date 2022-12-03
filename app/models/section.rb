class Section < ApplicationRecord
  has_many :tasks, dependent: :delete_all
  belongs_to :project

  delegate :user, to: :project
end
