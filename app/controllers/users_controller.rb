class UsersController < ApplicationController
  before_filter :configure_search
  respond_to :html

  def index
    respond_with @users
  end

  def search
    render :index
  end

  private

  def configure_search
    @search = User.search(params[:q])
    @search.build_grouping unless @search.groupings.any?
    @users  = params[:distinct].to_i.zero? ? @search.result : @search.result(distinct: true)
  end

end
