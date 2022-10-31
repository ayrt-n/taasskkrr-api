class Section < ApplicationRecord
  has_many :tasks, as: :taskable, dependent: :destroy
end
