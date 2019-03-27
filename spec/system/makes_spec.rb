require "rails_helper"

describe "自分ルール機能(make)", type: :system do
  let(:user_a) { FactoryBot.create(:user, name: "ユーザーA", email: "a@example.com") }
  let(:user_b) { FactoryBot.create(:user, name: "ユーザーB", email: "b@example.com") }
  let!(:make_a) { FactoryBot.create(:make, title: "最初のmake", user: user_a) }

  before do
    visit login_path
    fill_in "メールアドレス", with: login_user.email
    fill_in "パスワード", with: login_user.password
    click_button "ログイン"
  end

  describe "一覧表示機能" do
    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }

      it "ユーザーAが作成したルールが表示される" do
        expect(page).to have_content "最初のmake"
      end
    end

    context "ユーザーBがログインしているとき" do
      let(:login_user) { user_b }

      it "ユーザーAが作成したルールが表示されない" do
        expect(page).to have_no_content "最初のmake"
      end
    end
  end

  describe "詳細表示機能" do
    before do
      visit make_path(make_a)
    end

    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }

      it "ユーザーAが作成したmakeが表示される" do
        expect(page).to have_content "最初のmake"
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
        visit makes_new_1_path
        fill_in "make[title]", with: "筋トレ"
        click_button "次へ"
        click_button "次へ"
        fill_in "make[norm]", with: "１回スクワットをする"
        click_button "次へ"
        click_button "次へ"
        fill_in "make[rule1]", with: "歯磨きをしたら１回スクワットをする"
        click_button "次へ"
        click_button "次へ"
        fill_in "挫折しそうになる状況を入力してください", with: "めんどくさくなる"
        click_button "次へ"
        click_button "次へ"
        fill_in "make[rule2]", with: "めんどくさくなったら太ってる自分の写真を見返す"
        click_button "完成！"
      end

      it "正常に登録される" do
        expect(page).to have_selector ".alert-success", text: "自分ルールを作成しました！"
      end
    end

    context "項目を入力しなかったとき" do
      before do
        visit makes_new_1_path
        fill_in "make[title]", with: ""
        click_button "次へ"
      end

      it "次のページに遷移できない" do
        expect(page).to have_current_path makes_new_1_path
      end
    end
  end
end
