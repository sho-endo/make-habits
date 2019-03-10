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

    def forbid_login_user
      if logged_in?
        flash[:warning] = "すでにログインしています"
        redirect_to current_user
      end
    end
end
