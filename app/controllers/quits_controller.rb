class QuitsController < HabitsController
  before_action :check_login
  before_action :forbid_direct_access, except: [:new1, :show]
  before_action :set_title, only: [:new2, :new3, :new4, :new5, :new6, :new7]
  before_action :set_rule1, only: [:new6, :new7]
  before_action :check_correct_user, only: [:show]

  def new1
  end

  def new2
  end

  def new3
  end

  def new4
    @situation = params[:quit][:situation]
  end

  def new5
    @situation = params[:quit][:situation]
  end

  def new6
  end

  def new7
  end

  def create
    quit = current_user.quits.build(quit_params)
    if quit.save
      flash[:success] = "自分ルールを作成しました！"
      redirect_to quit
    else
      flash[:warning] = "データの保存に失敗しました。お手数ですがもう一度やり直してください。"
      redirect_to quits_new_1_url
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
      redirect_to quits_new_1_path if request.referer.nil?
    end

    def set_title
      @title = params[:quit][:title]
    end

    def set_rule1
      @rule1 = params[:quit][:rule1]
    end
end
