require "rails_helper"

describe "ユーザー機能", type: :system do
  describe "新規登録機能（メールアドレス）" do
    context "ユーザーの入力が正しいとき" do
      before do
        visit signup_path
        fill_in "user[name]", with: "tom"
        fill_in "user[email]", with: "tom@ne.jp"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        click_button "新規登録"
      end

      it "ユーザー登録が成功する" do
        expect(page).to have_selector ".alert-success", text: "ユーザー登録しました"
      end
    end

    context "パスワードが４文字だったとき" do
      before do
        visit signup_path
        fill_in "user[name]", with: "tom"
        fill_in "user[email]", with: "tom@ne.jp"
        fill_in "user[password]", with: "pass"
        fill_in "user[password_confirmation]", with: "pass"
        click_button "新規登録"
      end

      it "ユーザー登録に失敗する" do
        expect(page).to have_selector ".alert-warning", text: "パスワードは6文字以上で入力してください"
      end
    end
  end
end
