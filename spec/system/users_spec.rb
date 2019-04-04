require "rails_helper"

describe "ユーザー機能", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, name: "他のユーザー", email: "other_user@example.com") }
  let(:activated_user) { FactoryBot.create(:activated_user) }
  let(:admin_user) { FactoryBot.create(:admin_user) }

  let(:activation_mail) { ActionMailer::Base.deliveries.last }
  let(:password_reset_mail) { ActionMailer::Base.deliveries.last }

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

      it "ユーザーにアカウント有効化メールが送信される" do
        click_button submit
        expect(activation_mail.to).to eq ["tom@ne.jp"]
        expect(activation_mail.from).to eq ["noreply@example.com"]
        expect(activation_mail.subject).to match "アカウント有効化"
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

  describe "アカウント有効化機能" do
    context "正しいリンクからアクセスしたとき" do
      before do
        user.send_activation_email
        visit edit_account_activation_url(user.activation_token, email: user.email)
      end

      it "アカウントを有効化する" do
        within ".alert" do
          expect(page).to have_content "アカウントを有効化しました"
        end
        expect(user.reload.activated).to eq true
      end
    end

    context "無効なリンクからアクセスしたとき" do
      before do
        user.send_activation_email
        visit edit_account_activation_url("invalid_token", email: user.email)
      end

      it "アカウントを有効化しない" do
        within ".alert" do
          expect(page).to have_content "このリンクは無効です"
        end
        expect(user.reload.activated).to eq false
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

        it "アカウント有効化メールが送信される" do
          expect(activation_mail.to).to eq [new_email]
          expect(activation_mail.from).to eq ["noreply@example.com"]
          expect(activation_mail.subject).to match "アカウント有効化"
        end
      end

      context "入力が空のとき" do
        before do
          fill_in "user[name]", with: ""
          fill_in "user[email]", with: ""
          click_button "プロフィールを更新する"
        end

        it "リクエストを送信できない" do
          expect(page).to have_current_path edit_user_path(user)
        end
      end
    end

    describe "プロフィール画像更新機能" do
      context "正しい画像のとき" do
        before do
          attach_file "user[avatar]", "#{Rails.root}/spec/fixtures/icon.png", make_visible: true
          click_button "プロフィールを更新する"
        end

        it "更新に成功する" do
          within ".alert" do
            expect(page).to have_content "プロフィールを更新しました"
          end
        end
      end

      context "5MB以上の画像がフォームにセットされたとき" do
        before do
          attach_file "user[avatar]", "#{Rails.root}/spec/fixtures/large.jpg", make_visible: true
        end

        it "アラートが表示される" do
          expect(page.driver.browser.switch_to.alert.text).to eq "画像は５MB以下のものにしてください"
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

  describe "アカウント有効化メール再送信機能" do
    before { visit new_account_activation_path }

    context "メールアドレスが存在しないとき" do
      before { fill_in "account_activation[email]", with: "dummy@example.com" }

      it "メールは送信されない" do
        expect { click_button "メールを送信する" }.not_to change { ActionMailer::Base.deliveries }
        within ".alert" do
          expect(page).to have_content "メールアドレスが間違っているかすでに有効化されています"
        end
      end
    end

    context "すでにアカウントが有効化されているとき" do
      before { fill_in "account_activation[email]", with: activated_user.email }

      it "メールは送信されない" do
        expect { click_button "メールを送信する" }.not_to change { ActionMailer::Base.deliveries.count }
        within ".alert" do
          expect(page).to have_content "メールアドレスが間違っているかすでに有効化されています"
        end
      end
    end

    context "入力されたメールアドレスが正しいとき" do
      before { fill_in "account_activation[email]", with: user.email }

      it "メールが送信される" do
        expect { click_button "メールを送信する" }.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(activation_mail.to).to eq [user.email]
        within ".alert" do
          expect(page).to have_content "メールを送信しました"
        end
      end
    end
  end

  describe "パスワード再設定メール送信機能" do
    before { visit new_password_reset_path }

    context "登録されていないメールアドレスを入力したとき" do
      before { fill_in "password_reset[email]", with: "non-exist@example.com" }

      it "メールは送信されない" do
        expect { click_button "メールを送信する" }.not_to change { ActionMailer::Base.deliveries.count }
        within ".alert" do
          expect(page).to have_content "メールアドレスが間違っているかアカウントが有効化されていません"
        end
      end
    end

    context "アカウントが有効化されていないとき" do
      before { fill_in "password_reset[email]", with: user.email }

      it "メールは送信されない" do
        expect { click_button "メールを送信する" }.not_to change { ActionMailer::Base.deliveries.count }
        within ".alert" do
          expect(page).to have_content "メールアドレスが間違っているかアカウントが有効化されていません"
        end
      end
    end

    context "有効化されたアカウントのメールアドレスを入力したとき" do
      before { fill_in "password_reset[email]", with: activated_user.email }

      it "メールが送信される" do
        expect { click_button "メールを送信する" }.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(password_reset_mail.to).to eq [activated_user.email]
        within ".alert" do
          expect(page).to have_content "メールを送信しました"
        end
      end
    end
  end

  describe "パスワード再設定機能" do
    let(:new_password) { "newpassword" }

    before do
      activated_user.create_reset_digest and activated_user.reload
      activated_user.send_password_reset_email
    end

    context "リンクの期限が切れているとき" do
      before do
        activated_user.update!({ reset_sent_at: 3.hours.ago })
        visit edit_password_reset_url(activated_user.reset_token, email: activated_user.email)
      end

      it "パスワード再設定ページにアクセスできない" do
        within ".alert" do
          expect(page).to have_content "リンクの有効期限が切れています"
        end
        expect(page).to have_current_path new_password_reset_path
      end
    end

    context "リンクが正しくないとき" do
      before do
        visit edit_password_reset_url("invalid_token", email: activated_user.email)
      end

      it "パスワード再設定ページにアクセスできない" do
        within ".alert" do
          expect(page).to have_content "このリンクは無効です"
        end
        expect(page).to have_current_path root_path
      end
    end

    context "新しいパスワードの入力が正しいとき" do
      before do
        visit edit_password_reset_url(activated_user.reset_token, email: activated_user.email)
        fill_in "user[password]", with: new_password
        fill_in "user[password_confirmation]", with: new_password
        click_button "パスワードを変更する"
      end

      it "パスワードが変更される" do
        within ".alert" do
          expect(page).to have_content "パスワードを更新しました"
        end
        expect(activated_user.reload.authenticate(new_password)).to eq activated_user
      end
    end

    context "新しいパスワードの入力が正しくないとき" do
      before do
        visit edit_password_reset_url(activated_user.reset_token, email: activated_user.email)
        fill_in "user[password]", with: new_password
        fill_in "user[password_confirmation]", with: "hogehoge"
        click_button "パスワードを変更する"
      end

      it "パスワードは変更されない" do
        within ".error-message" do
          expect(page).to have_content "パスワードの入力が一致していません"
        end
        expect(activated_user.reload.authenticate(new_password)).to eq false
      end
    end
  end
end
