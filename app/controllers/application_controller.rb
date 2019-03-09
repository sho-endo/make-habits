class ApplicationController < ActionController::Base
  include SessionsHelper

  private

    def check_login
      unless logged_in?
        store_location
        flash[:warning] = "ログインしてください"
        redirect_to login_url
      end
    end
end
