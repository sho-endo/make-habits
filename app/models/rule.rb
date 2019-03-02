class Rule < ApplicationRecord
  validates :content, presence: true, length: { maximum: 255 }
  validates :habit_id, presence: true

  belongs_to :habit
end
