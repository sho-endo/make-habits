FactoryBot.define do
  factory :user do
    name { "一般ユーザー" }
    email { "test1@example.com" }
    password { "password" }
    avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/icon.png")) }
  end

  factory :test_user, class: User do
    name { "デモ用ユーザー" }
    email { "test_user@example.com" }
    password { "password" }
  end

  factory :admin_user, class: User do
    name { "管理ユーザー" }
    email { "admin@example.com" }
    password { "password" }
    admin { true }
  end

  factory :activated_user, class: User do
    name { "有効化されているユーザー" }
    email { "activated@example.com" }
    password { "password" }
    activated { true }
  end
end
