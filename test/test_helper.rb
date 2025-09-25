ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  private

  # Helper method to simulate controller action name for helper tests
  def stub_action_name(name)
    controller = UsersController.new
    controller.action_name = name
    @controller = controller
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers if defined?(Devise)
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers if defined?(Devise)
end
