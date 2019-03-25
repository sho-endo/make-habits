require "rails_helper"

describe "自分ルール作成機能", type: :system do
  describe "一覧表示機能" do
    before do
      user_a = FactoryBot.create(:user, name: "ユーザーA", email: "a@example.com")
      FactoryBot.create(:make, title: "最初のルール", user: user_a)
    end

    context "ユーザーAがログインしているとき" do
      before do
        visit login_path
        fill_in "login-email", with: "a@example.com"
        fill_in "login-pw", with: "password"
        click_button "ログイン"
      end

      it "ユーザーAが作成したルールが表示される" do
        expect(page).to have_content "最初のルール"
      end
    end

    context "ユーザーBがログインしているとき" do
      before do
        FactoryBot.create(:user, name: "ユーザーB", email: "b@example.com")
        visit login_path
        fill_in "login-email", with: "b@example.com"
        fill_in "login-pw", with: "password"
        click_button "ログイン"
      end

      it "ユーザーAが作成したルールが表示されない" do
        expect(page).to have_no_content "最初のルール"
      end
    end
  end
end
