class HabitsController < ApplicationController
  before_action :check_login

  def select
  end

  private

    def check_correct_user
      unless current_user.habits.find_by(id: params[:id])
        redirect_to current_user
      end
    end
end
