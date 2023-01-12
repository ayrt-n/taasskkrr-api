class Section < ApplicationRecord
  has_many :tasks, dependent: :delete_all
  belongs_to :project

  validates :title, presence: true

  delegate :user, to: :project
end
