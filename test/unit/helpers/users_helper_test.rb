require "test_helper"

class UsersHelperTest < ActionView::TestCase
  include UsersHelper

  def setup
    @controller = UsersController.new
    @controller.action_name = "index"
  end

  test "link_to_toggle_search_modes shows advanced link for index" do
    @controller.action_name = "index"
    link = link_to_toggle_search_modes
    assert_includes link, "Advanced Search"
    assert_includes link, "bg-indigo-600"
  end

  test "link_to_toggle_search_modes shows simple link for advanced_search" do
    @controller.action_name = "advanced_search"
    link = link_to_toggle_search_modes
    assert_includes link, "Simple Search"
    assert_includes link, "border-gray-300"
  end

  test "action returns correct method" do
    @controller.action_name = "index"
    assert_equal :get, action

    @controller.action_name = "advanced_search"
    assert_equal :post, action
  end

  test "display_distinct_label_and_check_box renders correctly" do
    result = display_distinct_label_and_check_box
    assert_includes result, 'type="checkbox"'
    assert_includes result, "Return distinct records"
    assert_includes result, "text-indigo-600"
  end

  test "user_wants_distinct_results? works with params" do
    params[:distinct] = "1"
    assert user_wants_distinct_results?

    params[:distinct] = "0"
    assert_not user_wants_distinct_results?

    params[:distinct] = nil
    assert_not user_wants_distinct_results?
  end

  test "display_results_header handles different counts" do
    header = display_results_header(5)
    assert_equal "Your 5 results", header

    header = display_results_header(1)
    assert_equal "Your 1 result", header

    header = display_results_header(15)
    assert_equal "Your first 10 results out of 15 total", header
  end

  test "display_query_sql formats SQL correctly" do
    users = User.limit(5)
    result = display_query_sql(users)
    assert_includes result, "SQL:"
    assert_includes result, users.to_sql
  end

  private

  def params
    @params ||= {}
  end

  def action_name
    @controller.action_name
  end
end
