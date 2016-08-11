class UsersController < ApplicationController
  def index
    @search = ransack_params
    @users  = ransack_result
  end

  def advanced_search
    @search = ransack_params
    @search.build_grouping unless @search.groupings.any?
    @users  = ransack_result
  end

  private
    def ransack_params
      User.includes(:posts).ransack(params[:q])
    end

    def ransack_result
      if params[:distinct].to_i.zero?
        @search.result
      else
        @search.result(distinct: true)
      end
    end
end
