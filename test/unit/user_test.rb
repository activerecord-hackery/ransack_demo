require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:john)
  end

  test "should have valid fixtures" do
    assert @user.valid?
    assert_equal "John", @user.first_name
    assert_equal "Doe", @user.last_name
    assert_equal "john.doe@example.com", @user.email
  end

  test "should have associations" do
    assert_respond_to @user, :posts
    assert_respond_to @user, :other_posts
    assert_respond_to @user, :comments
    assert_respond_to @user, :roles
  end

  test "should format datetime correctly" do
    assert_match %r{\d{2}/\d{2}/\d{2} \d{2}:\d{2}}, @user.created
    assert_match %r{\d{2}/\d{2}/\d{2} \d{2}:\d{2}}, @user.updated
  end

  test "should have ransackable attributes" do
    ransackable_attrs = User.ransackable_attributes
    assert_includes ransackable_attrs, "first_name"
    assert_includes ransackable_attrs, "last_name"
    assert_includes ransackable_attrs, "email"
    assert_includes ransackable_attrs, "full_name"
    assert_not_includes ransackable_attrs, "password_digest"
  end

  test "should have ransortable attributes" do
    ransortable_attrs = User.ransortable_attributes
    assert_includes ransortable_attrs, "first_name"
    assert_includes ransortable_attrs, "last_name"
    assert_includes ransortable_attrs, "email"
    assert_not_includes ransortable_attrs, "password_digest"
  end

  test "should have ransackable associations" do
    ransackable_assocs = User.ransackable_associations
    assert_includes ransackable_assocs, "posts"
    assert_includes ransackable_assocs, "other_posts"
  end

  test "should search by full name using ransacker" do
    search = User.ransack(full_name_cont: "John Doe")
    results = search.result
    assert_includes results, @user
  end

  test "should search by first or last name" do
    search = User.ransack(first_name_or_last_name_cont: "John")
    results = search.result
    assert_includes results, @user
  end

  test "should search by email" do
    search = User.ransack(email_cont: "john.doe")
    results = search.result
    assert_includes results, @user
  end

  test "should get postgres version" do
    version = User.postgres_version
    assert_not_nil version
    assert_kind_of String, version
    assert version.length > 0
  end
end
