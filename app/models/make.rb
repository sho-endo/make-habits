class Make < Habit
  validate :check_number_of_makes

  private

    def check_number_of_makes
      if user && user.makes.count >= 15
        errors.add(:base, "同時に作成できるルールは15個までです")
      end
    end
end
