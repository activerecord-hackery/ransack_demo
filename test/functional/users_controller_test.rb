require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get advanced search' do
    get :advanced_search
    assert_response :success
  end
end
