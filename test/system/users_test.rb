require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit users_url
    
    assert_selector "h1", text: "Search Users"
    assert_selector "form"
    assert_selector "input[placeholder*='Search by first or last name']"
    assert_selector "input[placeholder*='Search by email address']"
  end

  test "performing a simple search" do
    visit users_url
    
    # Search by name
    fill_in "Search by first or last name", with: "John"
    click_on "Search Users"
    
    # Should stay on the same page and show results
    assert_current_path users_path
    assert_selector "table" # Results table should be present
  end

  test "navigating to advanced search" do
    visit users_url
    
    click_on "Advanced Search"
    
    assert_current_path advanced_search_users_path
    assert_selector "h1", text: "Advanced User Search"
    assert_selector ".bg-green-50", text: "Sorting Options"
    assert_selector ".bg-purple-50", text: "Search Conditions"
  end

  test "performing an advanced search" do
    visit advanced_search_users_path
    
    # Should have default condition groups
    assert_selector ".bg-white.rounded-md", minimum: 1
    
    # Execute search
    click_on "Execute Search"
    
    # Should show results
    assert_selector "table" # Results table should be present
  end

  test "toggling between search modes" do
    # Start at simple search
    visit users_url
    assert_selector "h1", text: "Search Users"
    
    # Go to advanced search
    click_on "Advanced Search"
    assert_selector "h1", text: "Advanced User Search"
    
    # Go back to simple search
    click_on "Simple Search"
    assert_selector "h1", text: "Search Users"
  end

  test "distinct checkbox functionality" do
    visit users_url
    
    # Checkbox should be present
    assert_selector "input[type=checkbox]"
    assert_text "Return distinct records"
    
    # Check the box and submit
    check "Return distinct records"
    click_on "Search Users"
    
    # Should stay on the same page
    assert_current_path users_path
  end

  test "page layout and styling" do
    visit users_url
    
    # Check for modern layout elements
    assert_selector "header.bg-white.shadow"
    assert_selector "main.max-w-7xl"
    assert_selector "footer.bg-white.border-t"
    
    # Check for TailwindCSS classes in form
    assert_selector ".bg-gray-50.rounded-lg" # User Information section
    assert_selector ".bg-blue-50.rounded-lg" # User's Posts section
    
    # Check for modern button styling
    assert_selector ".bg-indigo-600", text: "Advanced Search"
  end
end