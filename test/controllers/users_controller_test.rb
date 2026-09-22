require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "index lists every user" do
    get users_url
    assert_response :success
    assert_select "h2", "Your 3 results"
    assert_result_emails %w[alice@example.com bob@example.com carol@example.com]
  end

  test "index filters by name through the alias" do
    get users_url, params: {q: {name_cont: "ali"}}
    assert_response :success
    assert_result_emails %w[alice@example.com]
    assert_select "input[name='q[name_cont]'][value=ali]"
  end

  test "index filters across several posts with scopes" do
    get users_url, params: {q: {with_post_titled: "Ruby on Rails", without_post_titled: "Elixir"}}
    assert_result_emails %w[alice@example.com]
    assert_select "input[name='q[with_post_titled]'][value='Ruby on Rails']"
  end

  test "index filters and sorts by posts count" do
    get users_url, params: {q: {posts_count_gteq: 1, s: "posts_count desc"}, distinct: 1}
    assert_result_emails %w[alice@example.com bob@example.com]
    assert_select "th a.sort_link.desc", /Posts/
  end

  test "index filters by a created date range" do
    day = users(:alice).created_at.to_date.to_s
    get users_url, params: {q: {created_at_gteq: day, created_at_lteq_end_of_day: day}}
    assert_select "h2", "Your 3 results"
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

  test "advanced search only offers extra values for multi-value predicates" do
    get advanced_search_users_url, params: {
      q: {g: {"0" => {c: {"0" => {a: {"0" => {name: "first_name"}}, p: "eq", v: {"0" => {value: "Alice"}}}}}}}
    }
    assert_select "[data-fields=condition] button[data-search-type-param=value][disabled]"

    get advanced_search_users_url, params: {
      q: {g: {"0" => {c: {"0" => {a: {"0" => {name: "first_name"}}, p: "in", v: {"0" => {value: "Alice"}}}}}}}
    }
    assert_select "[data-fields=condition] button[data-search-type-param=value]:not([disabled])"
  end

  test "advanced search with several values on a multi-value predicate" do
    get advanced_search_users_url, params: {
      q: {g: {"0" => {c: {"0" => {a: {"0" => {name: "first_name"}}, p: "in",
        v: {"0" => {value: "Alice"}, "1" => {value: "Carol"}}}}}}}
    }
    assert_response :success
    assert_result_emails %w[alice@example.com carol@example.com]
    assert_select "[data-fields=condition] input[name$='[value]'][value=Alice]"
    assert_select "[data-fields=condition] input[name$='[value]'][value=Carol]"
  end

  test "index filters by role and by tag through selects" do
    get users_url, params: {q: {roles_name_in: ["", "user"]}}
    assert_result_emails %w[bob@example.com carol@example.com]
    assert_select "select[name='q[roles_name_in][]'] option[selected][value=user]"

    get users_url, params: {q: {posts_tags_name_in: ["", "ruby", "web"]}, distinct: 1}
    assert_result_emails %w[alice@example.com]
  end

  test "advanced search renders a select for attributes with known values" do
    get advanced_search_users_url, params: {
      q: {g: {"0" => {c: {"0" => {a: {"0" => {name: "roles_name"}}, p: "eq", v: {"0" => {value: "admin"}}}}}}}
    }
    assert_response :success
    assert_result_emails %w[alice@example.com]
    assert_select "[data-fields=value] select[name='q[g][0][c][0][v][0][value]'] option[selected][value=admin]"
    assert_select "template[data-search-target=valueOptions][data-attribute=roles_name] option[value=admin]"
    assert_select "template[data-search-target=valueOptions][data-attribute=posts_tags_name] option[value=ruby]"
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
