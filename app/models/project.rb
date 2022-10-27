class Project < ApplicationRecord
  has_many :sections
  has_many :tasks, as: :taskable
end
