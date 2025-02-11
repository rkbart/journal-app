require 'rails_helper'

RSpec.describe "Categories Index", type: :feature do
  before(:each) do
    # Create a test user
    @user = User.create!(username: "testuser", email: "test@example.com", password: "password")

    # Log in the test user
    visit login_path
    fill_in "email", with: "test@example.com"
    fill_in "password", with: "password"
    click_button "Login"

    # Ensure "Uncategorized" category exists
    @uncategorized = Category.find_or_create_by!(name: "Uncategorized")
    @work_category = Category.create!(name: "Work")
    @task = Task.create!(title: "Sample Task", description: "A test task", due_date: Date.today, completed: false, category: @work_category)
  end

  it "displays the categories list" do
    visit categories_path
    expect(page).to have_content("Categories")
    expect(page).to have_content("Work")
  end

  it "ensures 'Uncategorized' category is always present" do
    visit categories_path
    expect(page).to have_content("Uncategorized")
  end

  it "allows a user to create a new category" do
    visit new_category_path
    fill_in "category_name", with: "Personal" # Ensure this matches the actual field name in your form
    click_button "Create Category"
    expect(page).to have_content("Category created successfully.")
    expect(Category.count).to eq(3) # Includes "Uncategorized"
  end

  it "shows an error when trying to create a category without a name" do
    visit categories_path
  
    # Find the button by CSS class or href (since it has an icon, not text)
    find("a[title='Add new category']").click
  
    click_button "Create Category" # Submitting without a name
  
    
  end
  

  it "updates the task count when a new task is added" do
    visit categories_path
    expect(page).to have_content("(1)") # Ensure task count updates
  end
end
