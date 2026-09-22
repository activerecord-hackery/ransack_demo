class UsersController < ApplicationController
  include UsersHelper

  def index
    @search = ransack_params
    @users = ransack_result
  end

  def advanced_search
    @search = ransack_params
    @search.build_grouping unless @search.groupings.any?
    @users = ransack_result
  end

  private

  def ransack_params
    # auth_object is normally a current user or role; here it tells the model
    # which form is asking, see User.ransackable_attributes.
    User.with_posts_count.includes(:posts, :roles).ransack(params[:q], auth_object: action_name.to_sym)
  end

  def ransack_result
    @search.result(distinct: user_wants_distinct_results?)
  end
end
