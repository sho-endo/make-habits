class UsersController < ApplicationController
  before_action :check_login, only: [:index, :show, :edit, :update_profile, :update_password, :delete, :destroy]
  before_action :forbid_twitter_login_user, only: [:edit, :update_profile, :update_password]
  before_action :check_correct_user, only: [:show, :edit, :update_profile, :update_password, :delete]
  before_action :check_admin, only: [:index]
  before_action :check_destroy, only: [:destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      log_in @user
      flash[:success] = "ユーザー登録しました"
      redirect_to @user
    else
      render :new
    end
  end

  def twitter_login
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    if user
      log_in user
      flash[:success] = "ログインしました"
      redirect_back_or user
    else
      flash[:warning] = "ログインに失敗しました"
      redirect_to new_user_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update_profile
    @user = User.find(params[:id])
    before_change_email = @user.email
    if @user.update_attributes(user_params)
      @user.reactivate unless @user.email == before_change_email
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user
    else
      render :edit
    end
  end

  def update_password
    @user = User.find(params[:id])
    unless @user.authenticate(params[:user][:current_password])
      @user.errors.add(:base, "現在のパスワードが違います")
      render :edit and return
    end
    if params[:user][:password].blank?
      @user.errors.add(:password, :blank)
      render :edit and return
    end
    if @user.update_attributes(user_params)
      flash[:success] = "パスワードを更新しました"
      redirect_to @user
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def delete
    @user = User.find(params[:id])
  end

  def destroy
    user = User.find(params[:id])
    redirect_back(fallback_location: root_url) and return if user.admin?
    user.destroy
    if current_user.admin?
      redirect_to admin_users_path
    else
      flash[:success] = "アカウントを削除しました"
      redirect_to root_url
    end

  end

  private
    def user_params
      params
        .require(:user)
        .permit(:name,
                :email,
                :password,
                :password_confirmation)
    end

    def check_login
      unless logged_in?
        store_location
        flash[:warning] = "ログインしてください"
        redirect_to login_url
      end
    end

    def forbid_twitter_login_user
      redirect_to(current_user) if current_user.provider == "twitter"
    end

    def check_correct_user
      @user = User.find(params[:id])
      redirect_to(current_user) unless @user == current_user
    end

    def check_admin
      redirect_to(current_user) unless current_user.admin?
    end

    def check_destroy
      @user = User.find(params[:id])
      redirect_to(current_user) unless (current_user.admin? || @user == current_user)
    end
end
