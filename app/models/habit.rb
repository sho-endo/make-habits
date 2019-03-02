class Habit < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :type, presence: true
  validates :user_id, presence: true

  belongs_to :user
  has_many :rules, dependent: :destroy
end
