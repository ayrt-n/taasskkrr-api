class Task < ApplicationRecord
  belongs_to :taskable, polymorphic: true
  belongs_to :user

  validates :title, presence: true
end
