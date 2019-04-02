FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    email { "test1@example.com" }
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
