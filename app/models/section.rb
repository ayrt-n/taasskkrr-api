class Section < ApplicationRecord
  has_many :tasks, as: :taskable, dependent: :destroy
  belongs_to :project

  delegate :user, to: :project
end
