require "rails_helper"

RSpec.describe Make, type: :model do
  let(:make) { FactoryBot.create(:make) }

  describe "有効なケース" do
    it { expect(make).to be_valid }
  end

  describe "無効なケース" do
    context "タイトルが無効な場合" do
      it "存在しない場合" do
        make.title = nil
        expect(make).not_to be_valid
      end

      it "256文字以上の場合" do
        make.title = "a" * 256
        expect(make).not_to be_valid
      end
    end

    context "rule1が無効な場合" do
      it "存在しない場合" do
        make.rule1 = nil
        expect(make).not_to be_valid
      end

      it "256文字以上の場合" do
        make.rule1 = "a" * 256
        expect(make).not_to be_valid
      end
    end

    context "rule2が無効な場合" do
      it "存在しない場合" do
        make.rule2 = nil
        expect(make).not_to be_valid
      end

      it "256文字以上の場合" do
        make.rule2 = "a" * 256
        expect(make).not_to be_valid
      end
    end

    context "typeが無効な場合" do
      it "存在しない場合" do
        make.type = nil
        expect(make).not_to be_valid
      end
    end

    context "user_idが無効な場合" do
      it "存在しない場合" do
        make.user_id = nil
        expect(make).not_to be_valid
      end
    end

    context "progressが無効な場合" do
      it "存在しない場合" do
        make.progress = nil
        expect(make).not_to be_valid
      end

      it "浮動小数の場合" do
        make.progress = 63.4
        expect(make).not_to be_valid
      end

      it "0以上100以下ではない整数の場合" do
        make.progress = 235
        expect(make).not_to be_valid
      end
    end

    context "16個以上作成しようとした場合" do
      let(:user) { FactoryBot.create(:user, email: "test@example.com") }
      before do
        15.times do
          user.makes.create!(
            title: "hoge",
            rule1: "foo",
            rule2: "bar",
          )
        end
      end

      it {
        expect(user.makes.build(
                 title: "hoge",
                 rule1: "foo",
                 rule2: "bar",
               )).not_to be_valid
      }
    end
  end
end
