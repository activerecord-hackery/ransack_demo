require "test_helper"

class UsersIntegrationTest < ActionDispatch::IntegrationTest
  test "can access index page" do
    get users_path
    assert_response :success
    assert_select "h1", "Search Users"
  end

  test "can access advanced search page" do
    get advanced_search_users_path
    assert_response :success
    assert_select "h1", "Advanced User Search"
  end

  test "can post to advanced search" do
    post advanced_search_users_path
    assert_response :success
    assert_select "h1", "Advanced User Search"
  end

  test "search with parameters works" do
    get users_path, params: { q: { first_name_cont: "John" } }
    assert_response :success
    assert_select "table" # Should show results table
  end

  test "search with distinct parameter works" do
    get users_path, params: { 
      q: { first_name_cont: "John" }, 
      distinct: "1" 
    }
    assert_response :success
    assert_select "table"
  end

  test "advanced search with complex parameters works" do
    post advanced_search_users_path, params: {
      q: {
        groupings: {
          "0" => {
            conditions: {
              "0" => {
                a: { "0" => { name: "first_name" } },
                p: "cont",
                v: { "0" => { value: "John" } }
              }
            }
          }
        }
      }
    }
    assert_response :success
    assert_select "table"
  end

  test "root path redirects to users index" do
    get root_path
    assert_response :success
    assert_select "h1", "Search Users"
  end

  test "page contains required elements" do
    get users_path
    assert_response :success
    
    # Check for form elements
    assert_select "form"
    assert_select "input[type=text]", minimum: 2
    assert_select "input[type=checkbox]"
    assert_select "input[type=submit]"
    
    # Check for navigation
    assert_select "a", text: /Advanced Search/
    
    # Check for footer
    assert_select "footer"
    assert_select "a[href*='github.com']"
  end

  test "advanced search page contains required elements" do
    get advanced_search_users_path
    assert_response :success
    
    # Check for form elements
    assert_select "form"
    assert_select "input[type=submit]"
    assert_select "input[type=checkbox]"
    
    # Check for navigation
    assert_select "a", text: /Simple Search/
    
    # Check for dynamic sections
    assert_select "button", text: /Add Sort/
    assert_select "button", text: /Add Condition Group/
  end
end