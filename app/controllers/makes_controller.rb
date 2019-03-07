class MakesController < ApplicationController
  before_action :check_login

  def new1
  end

  def new2
    @title = params[:make][:title]
    # 文字数判定はフォーム側でやる
  end

  def new3
    @title = params[:make][:title]
    @norm = params[:make][:norm]
  end

  def new4
    @title = params[:make][:title]
    @rule1 = params[:make][:rule1]
  end

  def new5
    @title = params[:make][:title]
    @rule1 = params[:make][:rule1]
    @situation = params[:make][:situation]
  end

  def create
    make = current_user.makes.build(make_params)
    if make.save
      flash[:success] = "自分ルールを作成しました！"
      redirect_to current_user
    else
      flash[:warning] = "データの保存に失敗しました。お手数ですがもう一度やり直してください。"
      redirect_to makes_new_1_url
    end
  end

  private

    def make_params
      params.require(:make).permit(:title, :rule1, :rule2)
    end
end
