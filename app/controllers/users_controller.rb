class UsersController < ApplicationController
  respond_to :html

  def index
    @search = User.search(params[:q])
    @users  = params[:distinct].to_i.zero? ?
      @search.result :
      @search.result(distinct: true)

    respond_with @users
  end

  def advanced_search
    @search = User.search(params[:q])
    @search.build_grouping unless @search.groupings.any?
    @users  = params[:distinct].to_i.zero? ?
      @search.result :
      @search.result(distinct: true)

    respond_with @users
  end
end
