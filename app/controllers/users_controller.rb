class UsersController < ApplicationController
  respond_to :html

  def index
    @search = User.search(params[:q])
    @users = ransack_result

    respond_with @users
  end

  def advanced_search
    @search = User.search(params[:q])
    @search.build_grouping unless @search.groupings.any?
    @users = ransack_result

    respond_with @users
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
