class Habit < ApplicationRecord
  include Hashid::Rails
  validates :title, presence: true, length: { maximum: 255 }
  validates :rule1, presence: true, length: { maximum: 255 }
  validates :rule2, presence: true, length: { maximum: 255 }
  validates :type, presence: true
  validates :user_id, presence: true
  validates :progress, presence: true,
                       numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  belongs_to :user
end
