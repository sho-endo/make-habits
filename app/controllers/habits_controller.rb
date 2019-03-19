class HabitsController < ApplicationController
  before_action :check_login
  before_action :check_correct_user, only: [:destroy]

  def select
  end

  def destroy
    current_user.habits.find(params[:id]).destroy!
    flash[:success] = "自分ルールを削除しました"
    redirect_to current_user
  end

  private

    def check_correct_user
      unless current_user.habits.find_by_hashid(params[:id]) # rubocop:disable Rails/DynamicFindBy
        redirect_to current_user
      end
    end
end
