User.create!(
  name: "admin_user",
  email: Rails.application.credentials.admin_user[:email],
  password: Rails.application.credentials.admin_user[:password],
  admin: true,
  activated: true,
)

User.create!(
  name: "test_user",
  email: "test_user@example.com",
  password: "test1234",
)
