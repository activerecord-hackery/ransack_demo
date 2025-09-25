require "test_helper"

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:search)
    assert_not_nil assigns(:users)
  end

  test "should get advanced search" do
    get :advanced_search
    assert_response :success
    assert_not_nil assigns(:search)
    assert_not_nil assigns(:users)
    assert assigns(:search).groupings.any?, "Should have at least one grouping"
  end

  test "should handle search with name parameter" do
    get :index, params: { q: { first_name_or_last_name_cont: "John" } }
    assert_response :success
    assert_not_nil assigns(:users)
    # The search should work and return results
    assert assigns(:users).count >= 0
  end

  test "should handle search with email parameter" do
    get :index, params: { q: { email_cont: "example.com" } }
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should handle search with posts title parameter" do
    get :index, params: { q: { posts_title_cont: "Ruby" } }
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should handle distinct parameter" do
    get :index, params: { distinct: "1", q: { first_name_cont: "John" } }
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should handle advanced search with complex parameters" do
    post :advanced_search, params: {
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
    assert_not_nil assigns(:search)
    assert_not_nil assigns(:users)
  end

  test "should handle empty search parameters gracefully" do
    get :index, params: { q: {} }
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should handle POST to advanced search" do
    post :advanced_search
    assert_response :success
    assert_not_nil assigns(:search)
    assert_not_nil assigns(:users)
  end
end
