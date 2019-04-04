require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  describe "有効なケース" do
    it { expect(user).to be_valid }

    it "メールアドレスは保存される前に小文字に変換される" do
      user.email = "HOGE@EXAMPLE.COM"
      user.save!
      expect(user.reload.email).to eq "hoge@example.com"
    end

    it "アバター画像の拡張子がjpgのとき" do
      image_path = File.join(Rails.root, "spec/fixtures/icon.jpg")
      user.avatar = File.open(image_path)
      expect(user).to be_valid
    end

    it "アバター画像の拡張子がjpegのとき" do
      image_path = File.join(Rails.root, "spec/fixtures/icon.jpeg")
      user.avatar = File.open(image_path)
      expect(user).to be_valid
    end

    it "アバター画像の拡張子がpngのとき" do
      image_path = File.join(Rails.root, "spec/fixtures/icon.png")
      user.avatar = File.open(image_path)
      expect(user).to be_valid
    end

    it "アバター画像の拡張子がgifのとき" do
      image_path = File.join(Rails.root, "spec/fixtures/icon.gif")
      user.avatar = File.open(image_path)
      expect(user).to be_valid
    end
  end

  describe "無効なケース" do
    context "ユーザー名が無効な場合" do
      it "存在しない場合" do
        user.name = nil
        expect(user).not_to be_valid
      end

      it "51文字以上の場合" do
        user.name = "a" * 51
        expect(user).not_to be_valid
      end
    end

    context "メールアドレスが無効な場合" do
      it "存在しない場合" do
        user.email = nil
        expect(user).not_to be_valid
      end

      it "256文字以上の場合" do
        user.email = "a" * 244 + "@example.com"
        expect(user).not_to be_valid
      end

      it "重複している場合" do
        User.create!(
          name: "tom",
          email: "tom@ne.jp",
          password: "password",
        )
        user.email = "tom@ne.jp"
        expect(user).not_to be_valid
      end

      it "フォーマットが間違っている場合" do
        user.email = "hogehoge"
        expect(user).not_to be_valid
      end
    end

    context "パスワードが無効な場合" do
      it "存在しない場合" do
        user.password = nil
        expect(user).not_to be_valid
      end

      it "5文字以下の場合" do
        user.password = "a" * 4
        expect(user).not_to be_valid
      end

      it "51文字以上の場合" do
        user.password = "a" * 51
        expect(user).not_to be_valid
      end
    end

    context "アバター画像が無効な場合" do
      let(:large_image_path) { File.join(Rails.root, "spec/fixtures/large.jpg") }
      let(:large_image) { Rack::Test::UploadedFile.new(large_image_path) }
      let(:invalid_file_path) { File.join(Rails.root, "spec/fixtures/invalid.rb") }

      it "5MB以上の場合" do
        user.avatar = large_image
        expect(user).not_to be_valid
      end

      it "拡張子がjpg, jpeg, gif, png以外の場合" do
        user.avatar = File.open(invalid_file_path)
        expect(user).not_to be_valid
      end
    end
  end
end
