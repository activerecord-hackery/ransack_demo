require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "full_name ransacker searches the concatenated name" do
    assert_equal [users(:alice)], User.ransack(full_name_eq: "Alice Smith").result.to_a
  end

  test "password_digest is not searchable or sortable" do
    assert_not_includes User.ransackable_attributes, "password_digest"
    assert_not_includes User.ransortable_attributes, "password_digest"
  end

  test "searchable associations are allowlisted" do
    assert_equal %w[posts other_posts comments roles], User.ransackable_associations
  end

  test "searches through roles and through posts to tags" do
    assert_equal [users(:alice)], User.ransack(roles_name_in: ["admin"]).result.to_a
    assert_equal [users(:bob)], User.ransack(posts_tags_name_in: ["functional"]).result.to_a
  end
end
