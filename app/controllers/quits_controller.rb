class QuitsController < ApplicationController
  before_action :check_login
  before_action :forbid_direct_access, except: [:new1]
  before_action :set_title, only: [:new2, :new3, :new4]

  def new1
  end

  def new2
  end

  def new3
    @situation = params[:quit][:situation]
  end

  def new4
    @rule1 = params[:quit][:rule1]
  end

  def create
    quit = current_user.quits.build(quit_params)
    if quit.save
      flash[:success] = "自分ルールを作成しました！"
      redirect_to current_user
    else
      flash[:warning] = "データの保存に失敗しました。お手数ですがもう一度やり直してください。"
      redirect_to quits_new_1_url
    end
  end

  private

    def quit_params
      params.require(:quit).permit(:title, :rule1, :rule2)
    end

    def forbid_direct_access
      redirect_to quits_new_1_path if request.referer.nil?
    end

    def set_title
      @title = params[:quit][:title]
    end
end
