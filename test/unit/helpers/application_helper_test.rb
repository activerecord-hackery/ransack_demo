require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  test "button_to_remove_fields generates correct button" do
    button = button_to_remove_fields
    assert_includes button, "Remove"
    assert_includes button, "remove_fields"
    assert_includes button, "border-red-300"
    assert_includes button, "text-red-700"
  end

  test "button_to_nest_fields generates correct button" do
    button = button_to_nest_fields(:grouping)
    assert_includes button, "Add Condition Group"
    assert_includes button, "nest_fields"
    assert_includes button, "border-purple-300"
    assert_includes button, "text-purple-700"
    assert_includes button, 'data-field-type="grouping"'
  end

  test "button_label returns correct labels" do
    labels = button_label
    assert_equal "Add Value", labels[:value]
    assert_equal "Add Condition", labels[:condition]
    assert_equal "Add Sort", labels[:sort]
    assert_equal "Add Condition Group", labels[:grouping]
  end

  test "app_info contains correct information" do
    info = app_info
    assert_includes info, "Ransack demo app"
    assert_includes info, "Rails"
    assert_includes info, "Ruby"
    assert_includes info, "Source code for this demo available on GitHub"
  end

  test "source_code_link returns correct link" do
    link = source_code_link
    assert_includes link, "Source code for this demo available on GitHub"
    assert_includes link, "https://github.com/activerecord-hackery/ransack_demo"
  end
end