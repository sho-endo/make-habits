class MakesController < HabitsController
  before_action :check_login
  before_action :forbid_direct_access, except: [:title, :show]
  before_action :check_number_of_makes, only: [:title]
  before_action :set_title, only: [:norm_description, :norm_input, :rule1_description, :rule1_input,
                                   :situation_description, :situation_input, :rule2_description, :rule2_input]
  before_action :set_rule1, only: [:situation_description, :situation_input, :rule2_description, :rule2_input]
  before_action :check_correct_user, only: [:show]

  def title
  end

  def norm_description
  end

  def norm_input
  end

  def rule1_description
    @norm = params[:make][:norm]
  end

  def rule1_input
    @norm = params[:make][:norm]
  end

  def situation_description
  end

  def situation_input
  end

  def rule2_description
    @situation = params[:make][:situation]
  end

  def rule2_input
    @situation = params[:make][:situation]
  end

  def create
    make = current_user.makes.build(make_params)
    if make.save
      flash[:success] = "自分ルールを作成しました！"
      redirect_to make
    else
      flash[:warning] = "データの保存に失敗しました。お手数ですがもう一度やり直してください。"
      redirect_to makes_title_url
    end
  end

  def update
    make = current_user.makes.find(params[:id])
    make.update!(make_params)
    head :no_content
  end

  def show
    @make = current_user.makes.find(params[:id])
  end

  private

    def make_params
      params.require(:make).permit(:title, :rule1, :rule2, :progress)
    end

    def forbid_direct_access
      redirect_to makes_title_path if request.referer.nil?
    end

    def check_number_of_makes
      if current_user.makes.count >= 50
        flash[:warning] = "同時に作成できるルールは50個ずつまでです"
        redirect_to current_user
      end
    end

    def set_title
      @title = params[:make][:title]
    end

    def set_rule1
      @rule1 = params[:make][:rule1]
    end
end
