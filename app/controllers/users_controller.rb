class UsersController < ApplicationController
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

  def show
    @user = User.find(params[:id])
  end

  def twitter_login
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    if user
      log_in user
      flash[:success] = "ログインしました"
      redirect_to user
    else
      flash[:warning] = "ログインに失敗しました"
      redirect_to new_user_path
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
end
