# MakeHabits

質問に答えていきながら、習慣づくりのための自分ルールを作成するアプリです。

## デモ
現在公開していません

## 実装した主な機能

* herokuを用いたデプロイ（現在公開していません）
* ユーザー認証機能
  * 認証まわりの勉強を兼ねてdevise等のgemを使わずに実装
  * ログイン,ログアウト,永続ログイン,アカウントロック,アカウント有効化, パスワード再設定など
* Twitterログイン機能
* メール送信機能
  * アカウント有効化とパスワード再設定の時に使用
  * 本番環境ではSendGridを使用
* 管理ユーザー機能
  * 管理ユーザーのみユーザー一覧へのアクセスと他のユーザーの削除が可能
  * ユーザー一覧ページではkaminariを用いてページネーション機能を実装
* 画像アップロード機能
  * carrierwaveとmini_magickを使用
  * 本番環境ではS3を使用
* DBテーブルのリレーション管理
* 単一テーブル継承（STI）機能
* ルールのCRUD機能
* ajaxを利用した非同期通信
* html2canvasを利用した画像ダウンロード機能
* rubocopの導入
* RSpecによる統合テスト,単体テスト

## バージョン

* ruby 2.5.1
* rails 5.2.2
* node 10.8.0
* yarn 1.9.4
* PostgreSQL 10.5
