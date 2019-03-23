class SessionsController < ApplicationController
  before_action :forbid_login_user, only: [:new, :create]
  before_action :set_user, only: [:create]
  before_action :check_locked, only: [:create]

  def new
  end

  def create
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      (params[:session][:remember_me] == "1") ? remember(@user) : forget(@user)
      @user.admin? ? redirect_to(admin_users_path) : redirect_back_or(@user)
      flash[:info] = "ログインしました"
    else
      @user.fail_login if @user
      flash.now[:danger] = if @user.locked?
                             "アカウントがロックされました。30分後に解除されます。"
                           else
                             "メールアドレスかパスワードが間違っています"
                           end
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:info] = "ログアウトしました"
    redirect_to root_url
  end

  private

    def set_user
      @email = params[:session][:email]
      @user = User.find_by(email: @email.downcase)
    end

    def check_locked
      if @user && @user.locked?
        flash.now[:warning] = "アカウントがロックされています。解除されるまでしばらくお待ちください。"
        render :new
      end
    end
end
