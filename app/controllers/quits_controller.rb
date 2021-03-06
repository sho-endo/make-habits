class QuitsController < HabitsController
  before_action :check_login
  before_action :forbid_direct_access, except: [:title, :show]
  before_action :check_number_of_quits, only: [:title]
  before_action :set_title, only: [:situation_description, :situation_input, :rule1_description, :rule1_input, :rule2_description, :rule2_input]
  before_action :set_rule1, only: [:rule2_description, :rule2_input]
  before_action :check_correct_user, only: [:show]

  def title
  end

  def situation_description
  end

  def situation_input
  end

  def rule1_description
    @situation = params[:quit][:situation]
  end

  def rule1_input
    @situation = params[:quit][:situation]
  end

  def rule2_description
  end

  def rule2_input
  end

  def create
    quit = current_user.quits.build(quit_params)
    if quit.save
      flash[:success] = "自分ルールを作成しました！"
      redirect_to quit
    else
      flash[:warning] = "データの保存に失敗しました。お手数ですがもう一度やり直してください。"
      redirect_to quits_title_url
    end
  end

  def update
    quit = current_user.quits.find(params[:id])
    quit.update!(quit_params)
    head :no_content
  end

  def show
    @quit = current_user.quits.find(params[:id])
  end

  private

    def quit_params
      params.require(:quit).permit(:title, :rule1, :rule2, :progress)
    end

    def forbid_direct_access
      redirect_to quits_title_path if request.referer.nil?
    end

    def check_number_of_quits
      if current_user.quits.count >= 50
        flash[:warning] = "同時に作成できるルールは50個ずつまでです"
        redirect_to current_user
      end
    end

    def set_title
      @title = params[:quit][:title]
    end

    def set_rule1
      @rule1 = params[:quit][:rule1]
    end
end
