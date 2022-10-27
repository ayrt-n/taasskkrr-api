class Section < ApplicationRecord
  has_many :tasks, as: :taskable
end
