require "rails_helper"

describe "自分ルール機能(quit)", type: :system do
  let(:user_a) { FactoryBot.create(:user, name: "ユーザーA", email: "a@example.com") }
  let(:user_b) { FactoryBot.create(:user, name: "ユーザーB", email: "b@example.com") }
  let!(:quit_a) { FactoryBot.create(:quit, title: "最初のquit", user: user_a) }

  before do
    visit login_path
    fill_in "session[email]", with: login_user.email
    fill_in "session[password]", with: login_user.password
    click_button "ログイン"
  end

  describe "一覧表示機能" do
    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }

      it "ユーザーAが作成したルールが表示される" do
        expect(page).to have_content "最初のquit"
      end
    end

    context "ユーザーBがログインしているとき" do
      let(:login_user) { user_b }

      it "ユーザーAが作成したルールが表示されない" do
        expect(page).to have_no_content "最初のquit"
      end
    end
  end

  describe "詳細表示機能" do
    before do
      visit quit_path(quit_a)
    end

    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }

      it "ユーザーAが作成したquitが表示される" do
        expect(page).to have_content "最初のquit"
      end
    end

    context "ユーザーBがログインしているとき" do
      let(:login_user) { user_b }

      it "ユーザーAが作成したルール詳細ページにはアクセスできない" do
        expect(page).to have_current_path user_path(user_b)
      end
    end
  end

  describe "新規作成機能" do
    let(:login_user) { user_a }

    context "全項目を入力したとき" do
      before do
        visit quits_new_1_path
        fill_in "quit[title]", with: "ついYouTubeを見てしまう"
        click_button "次へ"
        click_button "次へ"
        fill_in "quit[situation]", with: "自分の部屋で暇になったとき"
        click_button "次へ"
        click_button "次へ"
        fill_in "quit[rule1]", with: "自分の部屋で暇になったら本を読む"
        click_button "次へ"
        click_button "次へ"
        fill_in "quit[rule2]", with: "スマホからアプリを消してYouTubeはパソコンで見るようにする"
        click_button "完成！"
      end

      it "正常に登録される" do
        expect(page).to have_selector ".alert-success", text: "自分ルールを作成しました！"
      end
    end

    context "項目を入力しなかったとき" do
      before do
        visit quits_new_1_path
        fill_in "quit[title]", with: ""
        click_button "次へ"
      end

      it "次のページに遷移できない" do
        expect(page).to have_current_path quits_new_1_path
      end
    end
  end
end
