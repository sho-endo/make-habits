class MakesController < ApplicationController
  before_action :check_login
  before_action :forbid_direct_access, except: [:new1]
  before_action :set_title, only: [:new2, :new3, :new4, :new5, :new6, :new7, :new8, :new9]
  before_action :set_rule1, only: [:new6, :new7, :new8, :new9]

  def new1
  end

  def new2
  end

  def new3
  end

  def new4
    @norm = params[:make][:norm]
  end

  def new5
    @norm = params[:make][:norm]
  end

  def new6
  end

  def new7
  end

  def new8
    @situation = params[:make][:situation]
  end

  def new9
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

    def forbid_direct_access
      redirect_to makes_new_1_path if request.referer.nil?
    end

    def set_title
      @title = params[:make][:title]
    end

    def set_rule1
      @rule1 = params[:make][:rule1]
    end
end
