require "application_system_test_case"

class AdvancedSearchTest < ApplicationSystemTestCase
  test "building a condition narrows the results" do
    visit advanced_search_users_url

    click_on "Add Condition"
    within_last :condition do
      select "First name", from: attribute_select
      select "contains", from: predicate_select
      fill_in "Value", with: "ali"
    end
    click_on "Search"

    assert_text "Your 1 result"
    assert_result_emails %w[alice@example.com]
  end

  test "nesting a condition group combines with the parent combinator" do
    visit advanced_search_users_url

    click_on "Add Condition"
    within_last :condition do
      select "Last name", from: attribute_select
      select "equals", from: predicate_select
      fill_in "Value", with: "Smith"
    end

    click_on "Add Nested Group"
    within_last :grouping do
      click_on "Add Condition"
      within_last :condition do
        select "Email", from: attribute_select
        select "contains", from: predicate_select
        fill_in "Value", with: "bob"
      end
    end

    select "any", from: first("select[name$='[m]']")[:name]
    click_on "Search"

    assert_text "Your 2 results"
    assert_result_emails %w[alice@example.com bob@example.com]
  end

  test "removing a condition drops it from the search" do
    visit advanced_search_users_url

    click_on "Add Condition"
    within_last :condition do
      select "First name", from: attribute_select
      fill_in "Value", with: "nobody"
      click_on "Remove"
    end
    click_on "Search"

    assert_text "Your 3 results"
    assert_no_field "Value"
  end

  test "a sort field orders the results" do
    visit advanced_search_users_url

    click_on "Add Sort"
    within_last :sort do
      select "Email", from: find("select[name$='[name]']")[:name]
      select "descending", from: find("select[name$='[dir]']")[:name]
    end
    click_on "Search"

    assert_text 'ORDER BY "users"."email" DESC'
    assert_result_emails %w[carol@example.com bob@example.com alice@example.com]
  end

  private

  def within_last(type, &block)
    within(all("[data-fields=#{type}]").last, &block)
  end

  def attribute_select
    find("select[name$='[a][0][name]']")[:name]
  end

  def predicate_select
    find("select[name$='[p]']")[:name]
  end

  def assert_result_emails(emails)
    assert_equal emails, all("tbody tr td:nth-child(4)").map(&:text)
  end
end
