class AccountActivationsController < ApplicationController
  def new
  end

  def create
    @email = params[:account_activation][:email]
    @user = User.find_by(email: @email.downcase)
    unless @user
      flash.now[:warning] = "メールアドレスが間違っているかすでに有効化されています"
      render :new and return
    end
    if @user.activated?
      flash.now[:warning] = "メールアドレスが間違っているかすでに有効化されています"
      render :new
    else
      @user.resend_activation_email
      flash[:info] = "メールを送信しました"
      redirect_to root_url
    end
  end

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "アカウントを有効化しました"
      redirect_to user
    else
      flash[:danger] = "このリンクは無効です"
      redirect_to root_url
    end
  end
end
