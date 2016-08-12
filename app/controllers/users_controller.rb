class UsersController < ApplicationController
  include UsersHelper

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
      @search.result(distinct: user_wants_distinct_results?)
    end
end
