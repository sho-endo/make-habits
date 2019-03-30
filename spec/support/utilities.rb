def set_omniauth
  OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
    "provider" => "twitter",
    "uid" => "mock_uid_1234",
    "info" => {
      "name" => "Mock User",
      "image" => "http://mock_image_url.com",
    },
    "credentials" => {
      "token" => "mock_credentials_token",
      "secret" => "mock_credentials_secret",
    },
    "extra" => {
      "raw_info" => {
        "name" => "Mock User",
        "id" => "mock_uid_1234",
      },
    },
  })
end

def login_as(user)
  visit login_path
  fill_in "session[email]", with: user.email
  fill_in "session[password]", with: user.password
  click_button "ログイン"
end
