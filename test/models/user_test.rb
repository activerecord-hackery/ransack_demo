require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "name alias searches first or last name" do
    assert_equal [users(:alice)], User.ransack(name_cont: "ali").result.to_a
    assert_equal [users(:bob)], User.ransack(name_eq: "Jones").result.to_a
  end

  test "scopes combine conditions across different posts" do
    assert_equal [users(:alice)],
      User.ransack(with_post_titled: "Ruby on Rails", without_post_titled: "Elixir").result.to_a
    assert_equal [], User.ransack(with_post_titled: "Ruby on Rails", without_post_titled: "Rust").result.to_a
    assert_equal User.count, User.ransack(with_post_titled: "").result.count
  end

  test "posts_count ransacker filters and sorts" do
    assert_equal [users(:alice)], User.ransack(posts_count_gteq: 2).result.to_a
    assert_equal [users(:alice), users(:bob), users(:carol)],
      User.ransack(s: "posts_count desc").result.to_a
  end

  test "posts_count sorts with distinct results and a join" do
    users = User.with_posts_count.ransack(posts_title_cont: "R", s: "posts_count desc").result(distinct: true)
    assert_equal [["Alice", 2], ["Bob", 1]], users.map { |u| [u.first_name, u.posts_count] }
  end

  test "counting the posts that matched the search, per user" do
    counts = User.ransack(posts_title_cont: "R").result.group("users.id").count
    assert_equal({users(:alice).id => 2, users(:bob).id => 1}, counts)
  end

  test "custom end-of-day predicate widens a date to the end of that day" do
    day = users(:alice).created_at.to_date
    assert_includes User.ransack(created_at_lteq_end_of_day: day.to_s).result, users(:alice)
    assert_not_includes User.ransack(created_at_lteq: day.to_s).result, users(:alice)
  end

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
