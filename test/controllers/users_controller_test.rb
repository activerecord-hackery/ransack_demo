require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "index lists every user" do
    get users_url
    assert_response :success
    assert_select "h2", "Your 3 results"
    assert_result_emails %w[alice@example.com bob@example.com carol@example.com]
  end

  test "index filters by name" do
    get users_url, params: {q: {first_name_or_last_name_cont: "ali"}}
    assert_response :success
    assert_result_emails %w[alice@example.com]
  end

  test "index filters through the posts association" do
    get users_url, params: {q: {posts_title_cont: "Ru"}, distinct: 1}
    assert_response :success
    assert_result_emails %w[alice@example.com]
  end

  test "index sorts by column" do
    get users_url, params: {q: {s: "first_name desc"}}
    assert_response :success
    assert_result_emails %w[carol@example.com bob@example.com alice@example.com]
  end

  test "advanced search renders an empty grouping" do
    get advanced_search_users_url
    assert_response :success
    assert_select "fieldset.fields select[name='q[g][0][m]']"
  end

  test "advanced search filters with nested conditions" do
    post advanced_search_users_url, params: {
      q: {
        g: {
          "0" => {
            m: "or",
            c: {
              "0" => {a: {"0" => {name: "first_name"}}, p: "eq", v: {"0" => {value: "Alice"}}},
              "1" => {a: {"0" => {name: "email"}}, p: "cont", v: {"0" => {value: "bob"}}}
            }
          }
        }
      }
    }
    assert_response :success
    assert_result_emails %w[alice@example.com bob@example.com]
  end

  test "advanced search ignores attributes that are not allowlisted" do
    post advanced_search_users_url, params: {
      q: {g: {"0" => {c: {"0" => {a: {"0" => {name: "password_digest"}}, p: "cont", v: {"0" => {value: "x"}}}}}}}
    }
    assert_response :success
    assert_result_emails %w[alice@example.com bob@example.com carol@example.com]
  end

  private

  def assert_result_emails(emails)
    assert_equal emails, css_select("tbody tr td:nth-child(4)").map(&:text)
  end
end
