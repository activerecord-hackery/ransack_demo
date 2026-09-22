require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "root highlights the simple search in the navigation" do
    get root_url
    assert_select "nav a[aria-current=page]", "Simple search"
    get advanced_search_users_url
    assert_select "nav a[aria-current=page]", "Advanced search"
  end

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
    assert_select "fieldset[data-fields] select[name='q[g][0][m]']"
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

  test "advanced search accepts a combinator in any case" do
    post advanced_search_users_url, params: {
      q: {
        g: {
          "0" => {
            m: "OR",
            c: {
              "0" => {a: {"0" => {name: "first_name"}}, p: "eq", v: {"0" => {value: "Alice"}}},
              "1" => {a: {"0" => {name: "first_name"}}, p: "eq", v: {"0" => {value: "Carol"}}}
            }
          }
        }
      }
    }
    assert_response :success
    assert_result_emails %w[alice@example.com carol@example.com]
  end

  test "LIKE wildcards typed by the user are matched literally" do
    get users_url, params: {q: {first_name_cont: "%"}}
    assert_response :success
    assert_result_emails []
    assert_select "h2", "Your 0 results"
  end

  test "footer reports the ransack version" do
    get users_url
    assert_select "footer", /Ransack #{Regexp.escape(Ransack::VERSION)}/
  end

  test "advanced search re-selects the submitted attribute and predicate" do
    get advanced_search_users_url, params: {
      q: {g: {"0" => {c: {"0" => {a: {"0" => {name: "email"}}, p: "cont", v: {"0" => {value: "bob"}}}}}}}
    }
    assert_response :success
    assert_select "select[name='q[g][0][c][0][a][0][name]'] option[selected][value=email]"
    assert_select "select[name='q[g][0][c][0][p]'] option[selected][value=cont]"
    assert_select "input[name='q[g][0][c][0][v][0][value]'][value=bob]"
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
