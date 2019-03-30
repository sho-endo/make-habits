require "rails_helper"

RSpec.describe Habit, type: :model do
  let(:habit) { FactoryBot.create(:make) }

  describe "有効なケース" do
    it { expect(habit).to be_valid }
  end

  describe "無効なケース" do
    context "タイトルが無効な場合" do
      it "存在しない場合" do
        habit.title = nil
        expect(habit).not_to be_valid
      end

      it "256文字以上の場合" do
        habit.title = "a" * 256
        expect(habit).not_to be_valid
      end
    end

    context "rule1が無効な場合" do
      it "存在しない場合" do
        habit.rule1 = nil
        expect(habit).not_to be_valid
      end

      it "256文字以上の場合" do
        habit.rule1 = "a" * 256
        expect(habit).not_to be_valid
      end
    end

    context "rule2が無効な場合" do
      it "存在しない場合" do
        habit.rule2 = nil
        expect(habit).not_to be_valid
      end

      it "256文字以上の場合" do
        habit.rule2 = "a" * 256
        expect(habit).not_to be_valid
      end
    end

    context "typeが無効な場合" do
      it "存在しない場合" do
        habit.type = nil
        expect(habit).not_to be_valid
      end
    end

    context "user_idが無効な場合" do
      it "存在しない場合" do
        habit.user_id = nil
        expect(habit).not_to be_valid
      end
    end
  end
end
