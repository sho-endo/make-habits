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

def login_as(user, options = {})
  if options[:no_capybara]
    # Capybaraを使用していない場合でもログインできるようにする
    remember_token = User.new_token
    user.update!({ remember_digest: User.digest(remember_token) })
    test_cookies = ActionDispatch::Request.new(Rails.application.env_config.deep_dup).cookie_jar
    test_cookies.signed[:user_id] = user.id
    cookies[:user_id] = test_cookies[:user_id]
    cookies[:remember_token] = remember_token
  else
    visit login_path
    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: user.password
    click_button "ログイン"
  end
end
