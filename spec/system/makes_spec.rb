require "rails_helper"

describe "自分ルール機能(make)", type: :system do
  let(:user_a) { FactoryBot.create(:user, name: "ユーザーA", email: "a@example.com") }
  let(:user_b) { FactoryBot.create(:user, name: "ユーザーB", email: "b@example.com") }
  let!(:make_a) { FactoryBot.create(:make, title: "最初のmake", user: user_a) }

  before do
    visit login_path
    login_as login_user
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
        visit makes_title_path
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
        within ".alert" do
          expect(page).to have_content "自分ルールを作成しました！"
        end
      end
    end

    context "項目を入力しなかったとき" do
      before do
        visit makes_title_path
        fill_in "make[title]", with: ""
        click_button "次へ"
      end

      it "次のページに遷移できない" do
        expect(page).to have_current_path makes_title_path
      end
    end

    context "すでに50個のルールがあるとき" do
      before do
        # 上記のテストで１つ作成されているためここでは49個
        49.times do
          login_user.makes.create!(
            title: "hoge",
            rule1: "foo",
            rule2: "bar",
          )
        end
        visit makes_title_path
      end

      it "マイページにリダイレクトされる" do
        within ".alert" do
          expect(page).to have_content "同時に作成できるルールは50個ずつまでです"
        end
        expect(page).to have_current_path user_path(login_user)
      end
    end
  end

  describe "削除機能" do
    let(:login_user) { user_a }

    before do
      visit make_path(make_a)
      click_link "ルールを削除する"
      page.driver.browser.switch_to.alert.accept
    end

    it "自分の作成したルールを削除できる" do
      within ".alert" do
        expect(page).to have_content "自分ルールを削除しました"
      end
    end
  end
end
