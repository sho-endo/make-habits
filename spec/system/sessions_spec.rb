require "rails_helper"

describe "セッション機能", type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe "ログイン機能" do
    before { visit login_path }

    context "入力が正しいとき" do
      before do
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_button "ログイン"
      end

      it "ログインできる" do
        within ".alert" do
          expect(page).to have_content "ログインしました"
        end
        expect(page).to have_content user.name
      end
    end

    context "パスワードが間違っているとき" do
      before do
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: "hogehoge"
        click_button "ログイン"
      end

      it "ログインに失敗する" do
        within ".alert" do
          expect(page).to have_content "メールアドレスかパスワードが間違っています"
        end
        expect(page).not_to have_content user.name
        expect(page).to have_current_path login_path
      end
    end
  end

  describe "ログアウト機能" do
    before do
      login_as user
      click_link user.name
      click_link "ログアウト"
    end

    it "ログアウトできる" do
      within ".alert" do
        expect(page).to have_content "ログアウトしました"
      end
      expect(page).to have_current_path root_path
      expect(page).not_to have_content user.name
    end
  end
end
