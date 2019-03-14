class PasswordResetsController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @email = params[:password_reset][:email]
    @user = User.find_by(email: @email.downcase)
    unless @user
      flash.now[:danger] = "メールアドレスが間違っています"
      render :new and return
    end
    if @user.activated
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "メールを送信しました"
      redirect_to root_url
    else
      flash.now[:danger] = "アカウントが有効化されていません"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      # ユーザー編集機能を作る際にUserモデルのpasswordに,
      # allow_nill: trueを実装しても不具合が起こらないようにするため
      @user.errors.add(:password, :blank)
      render :edit
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil) # rubocop:disable Rails/SkipsModelValidations
      flash[:success] = "パスワードを更新しました"
      redirect_to @user
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def set_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      unless @user && @user.activated? &&
             @user.authenticated?(:reset, params[:id])
        flash[:danger] = "このリンクは無効です"
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "リンクの有効期限が切れています"
        redirect_to new_password_reset_url
      end
    end
end
