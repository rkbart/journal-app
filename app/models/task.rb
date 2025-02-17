class Task < ApplicationRecord
  belongs_to :category
  validates :description, presence: true
end
