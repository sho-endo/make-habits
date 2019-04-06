class Quit < Habit
  validate :check_number_of_quits

  private

    def check_number_of_quits
      if user && user.quits.count >= 50
        errors.add(:base, "同時に作成できるルールは50個までです")
      end
    end
end
