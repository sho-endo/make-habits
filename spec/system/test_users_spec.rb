require "rails_helper"

describe "テストユーザー機能", type: :system do
  let(:test_user) { FactoryBot.create(:test_user) }
  before { login_as test_user }

  describe "プロフィール編集機能" do
    before { visit edit_user_path(test_user) }

    describe "アバター画像編集" do
      before do
        attach_file "user[avatar]", "#{Rails.root}/spec/fixtures/icon.png", make_visible: true
        click_button "プロフィール画像を更新する"
      end

      it "アバター画像は更新できる" do
        within ".alert" do
          expect(page).to have_content "プロフィール画像を更新しました"
        end
      end
    end

    describe "ユーザー名/メールアドレス編集" do
      it "ユーザー名とメールアドレスのフォームの値は編集できない" do
        expect(page).to have_field "ユーザー名", with: test_user.name, readonly: true
        expect(page).to have_field "メールアドレス", with: test_user.email, readonly: true
      end
    end

    describe "パスワード編集" do
      before do
        page.execute_script('$("#profile-edit").removeClass("show active")')
        page.execute_script('$("#password-edit").addClass("show active")')
      end

      it "フォームの編集と更新ボタンのクリックができない" do
        expect(page).to have_field "user[current_password]", placeholder: "現在のパスワード", readonly: true
        expect(page).to have_field "user[password]", placeholder: "新しいパスワード（６文字以上）", readonly: true
        expect(page).to have_field "user[password_confirmation]", placeholder: "新しいパスワード（確認）", readonly: true
        expect(page).to have_button "パスワードを更新する", disabled: true
      end
    end
  end

  describe "アカウント削除機能" do
    before { visit delete_page_path(test_user) }

    it "削除ボタンをクリックできない" do
      expect(page).to have_button "アカウントを削除する", disabled: true
    end
  end
end
