require "rails_helper"

RSpec.describe Quit, type: :model do
  let(:quit) { FactoryBot.create(:quit) }

  describe "有効なケース" do
    it { expect(quit).to be_valid }
  end

  describe "無効なケース" do
    context "タイトルが無効な場合" do
      it "存在しない場合" do
        quit.title = nil
        expect(quit).not_to be_valid
      end

      it "256文字以上の場合" do
        quit.title = "a" * 256
        expect(quit).not_to be_valid
      end
    end

    context "rule1が無効な場合" do
      it "存在しない場合" do
        quit.rule1 = nil
        expect(quit).not_to be_valid
      end

      it "256文字以上の場合" do
        quit.rule1 = "a" * 256
        expect(quit).not_to be_valid
      end
    end

    context "rule2が無効な場合" do
      it "存在しない場合" do
        quit.rule2 = nil
        expect(quit).not_to be_valid
      end

      it "256文字以上の場合" do
        quit.rule2 = "a" * 256
        expect(quit).not_to be_valid
      end
    end

    context "typeが無効な場合" do
      it "存在しない場合" do
        quit.type = nil
        expect(quit).not_to be_valid
      end
    end

    context "user_idが無効な場合" do
      it "存在しない場合" do
        quit.user_id = nil
        expect(quit).not_to be_valid
      end
    end

    context "progressが無効な場合" do
      it "存在しない場合" do
        quit.progress = nil
        expect(quit).not_to be_valid
      end

      it "浮動小数の場合" do
        quit.progress = 63.4
        expect(quit).not_to be_valid
      end

      it "0以上100以下ではない整数の場合" do
        quit.progress = 235
        expect(quit).not_to be_valid
      end
    end

    context "51個以上作成しようとした場合" do
      let(:user) { FactoryBot.create(:user, email: "test@example.com") }
      before do
        50.times do
          user.quits.create!(
            title: "hoge",
            rule1: "foo",
            rule2: "bar",
          )
        end
      end

      it {
        expect(user.quits.build(
                 title: "hoge",
                 rule1: "foo",
                 rule2: "bar",
               )).not_to be_valid
      }
    end
  end
end
