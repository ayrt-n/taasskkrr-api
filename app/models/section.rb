class Section < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :project

  delegate :user, to: :project
end
