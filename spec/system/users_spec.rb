require "rails_helper"

describe "ユーザー機能", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, name: "他のユーザー", email: "other_user@example.com") }
  let(:admin_user) { FactoryBot.create(:admin_user) }

  describe "新規登録機能（メールアドレス）" do
    let(:submit) { "新規登録" }

    before { visit signup_path }

    context "ユーザーの入力が正しいとき" do
      before do
        fill_in "user[name]", with: "tom"
        fill_in "user[email]", with: "tom@ne.jp"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
      end

      it "ユーザー登録が成功する" do
        expect { click_button submit }.to change { User.count }.by(1)
        expect(page).to have_selector ".alert-success", text: "ユーザー登録しました"
      end
    end

    context "ユーザーの入力が空のとき" do
      it "リクエストを送信できない" do
        click_button submit
        expect(page).to have_current_path signup_path
      end
    end
  end

  describe "新規登録機能（Twitter）" do
    let(:submit) { "twitter-signup" }

    before do
      visit signup_path
      set_omniauth
      click_link submit
    end

    context "認証情報が正しいとき" do
      it "ユーザー登録に成功する" do
        within ".alert" do
          expect(page).to have_content "ログインしました"
        end
      end
    end
  end

  describe "ユーザー一覧機能" do
    context "管理ユーザーとしてログインしているとき" do
      before { login_as admin_user }

      it "アクセスできる" do
        expect(page).to have_current_path admin_users_path
      end
    end

    context "一般ユーザーとしてログインしているとき" do
      before do
        login_as user
        visit admin_users_path
      end

      it "アクセスできない" do
        expect(page).not_to have_current_path admin_users_path
      end
    end
  end

  describe "プロフィール編集機能" do
    before do
      login_as user
      visit edit_user_path(user)
    end

    it "他のユーザーの編集ページにはアクセスできない" do
      visit edit_user_path(other_user)
      expect(page).not_to have_current_path edit_user_path(other_user)
      expect(page).to have_current_path user_path(user)
    end

    describe "ユーザー名/メールアドレス編集" do
      context "入力が正しいとき" do
        let(:new_name) { "New Name" }
        let(:new_email) { "new@example.com" }

        before do
          fill_in "user[name]", with: new_name
          fill_in "user[email]", with: new_email
          click_button "プロフィールを更新する"
        end

        it "更新に成功する" do
          within ".alert" do
            expect(page).to have_content "プロフィールを更新しました"
          end
          expect(user.reload.name).to eq new_name
          expect(user.reload.email).to eq new_email
        end
      end

      context "入力が空のとき" do
        before do
          fill_in "user[name]", with: ""
          fill_in "user[email]", with: ""
        end

        it "リクエストを送信できない" do
          expect(page).to have_current_path edit_user_path(user)
        end
      end
    end

    describe "パスワード編集" do
      before do
        page.execute_script('$("#profile-edit").removeClass("show active")')
        page.execute_script('$("#password-edit").addClass("show active")')
      end

      context "入力が正しいとき" do
        before do
          fill_in "user[current_password]", with: "password"
          fill_in "user[password]", with: "foobar"
          fill_in "user[password_confirmation]", with: "foobar"
          click_button "パスワードを更新する"
        end

        it "更新に成功する" do
          within ".alert" do
            expect(page).to have_content "パスワードを更新しました"
          end
        end
      end

      context "現在のパスワードが間違っているとき" do
        before do
          fill_in "user[current_password]", with: "hogehoge"
          fill_in "user[password]", with:   "foobar"
          fill_in "user[password_confirmation]", with: "foobar"
          click_button "パスワードを更新する"
        end

        it "更新に失敗する" do
          within ".error-message" do
            expect(page).to have_content "現在のパスワードが違います"
          end
        end
      end

      context "新しいパスワードと確認の入力が異なるとき" do
        before do
          fill_in "user[current_password]", with: "password"
          fill_in "user[password]", with: "foobar"
          fill_in "user[password_confirmation]", with: "hogehoge"
          click_button "パスワードを更新する"
        end

        it "更新に失敗する" do
          within ".error-message" do
            expect(page).to have_content "パスワードの入力が一致していません"
          end
        end
      end
    end
  end

  describe "アカウント削除機能" do
    context "一般ユーザーとしてログインしているとき" do
      before do
        login_as user
        visit delete_page_path(user)
      end

      it "自分のアカウントを削除できる" do
        click_link "アカウントを削除する"
        page.driver.browser.switch_to.alert.accept
        within ".alert" do
          expect(page).to have_content "アカウントを削除しました"
        end
      end

      it "他のユーザーのアカウント削除ページにはアクセスできない" do
        visit delete_page_path(other_user)
        expect(page).not_to have_current_path delete_page_path(other_user)
      end
    end

    context "管理ユーザーとしてログインしているとき" do
      before do
        login_as admin_user
        visit admin_users_path
      end

      it "他の一般ユーザーを削除できる" do
        expect(page).to have_content user.name
        click_link "削除", match: :first
        page.driver.browser.switch_to.alert.accept
        expect(page).not_to have_content user.name
      end
    end
  end
end
