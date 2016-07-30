class UsersController < ApplicationController
  def index
    @search = User.search(params[:q])
    @users = ransack_result
  end

  def advanced_search
    @search = User.search(params[:q])
    @search.build_grouping unless @search.groupings.any?
    @users = ransack_result
  end

  private
    def ransack_result
      if params[:distinct].to_i.zero?
        @search.result
      else
        @search.result(distinct: true)
      end
    end
end
