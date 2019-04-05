class Quit < Habit
  validate :check_number_of_quits

  private

    def check_number_of_quits
      if user && user.quits.count >= 15
        errors.add(:base, "同時に作成できるルールは15個までです")
      end
    end
end
