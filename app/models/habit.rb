class Habit < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :rule1, presence: true, length: { maximum: 255 }
  validates :rule2, presence: true, length: { maximum: 255 }
  validates :type, presence: true
  validates :user_id, presence: true

  belongs_to :user
end
