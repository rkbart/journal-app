require 'rails_helper'

RSpec.describe "Categories Index", type: :feature do
  before(:each) do
    @user = User.create!(username: "testuser", 
                         email: "test@example.com", 
                         password: "password")
    
    visit login_path

    fill_in "email", with: "test@example.com"
    fill_in "password", with: "password"
    click_button "Login"

    @category = Category.create!(name: "Work", 
                                 user: @user)

    @task = Task.create!(title: "Sample Task", 
                         description: "A test task", 
                         due_date: Date.today, 
                         completed: false, 
                         category: @category)
  end

  #User Story 1 create a new category 
  it "allows a user to create a new category" do
    visit new_category_path
    fill_in "category_name", with: "Personal" 
    click_button "Create Category"

    expect(page).to have_content("Category created successfully.")
    expect(page).to have_content("Personal")
  end

  #User Story #2 update a category
  it "allows a user to update a category" do
    visit edit_category_path(@category)
      # puts category.to_json
    
    fill_in "category_name", with: "Updated Work Name" 
    click_button "Update Category"

    expect(page).to have_content(" updated successfully.")
    expect(page).to have_content("Updated Work Name")
  end

  #User Story 3 view a category and all categories
  it "displays a category" do
    visit categories_path
    click_link "Work" 
    
    expect(page).to have_content("A test task")
  end
  
  it "displays the categories list" do
    visit categories_path

    expect(page).to have_content("Categories")
    expect(page).to have_content("Work")
  end

  #User Story #4 create a task for a specific category
  it "allows a user to create a new task within a category" do
    
    visit new_category_task_path(@category)
    
    fill_in "task_description", with: "This is a task description"
    fill_in "task_due_date", with: "2025-12-31" 
    click_button "Save Task"
  
    expect(page).to have_content("Task created successfully.") 
  end

  # User Story #5: Update a task within a category
  it "allows a user to update a task within a category" do
    
    visit edit_category_task_path(@category, @task)

    fill_in "task_description", with: "Updated task description"
    fill_in "task_due_date", with: "2026-01-01" 

    click_button "Save Task"

    expect(page).to have_content("Task updated successfully.") 
    expect(page).to have_content("2026-01-01")                 
  end

   #User Story 6 view all tasks/a task.
   it "displays the all tasks list" do
    visit all_tasks_categories_path

    expect(page).to have_content("All Tasks")

    expect(page).to have_content(@task.description) 
    expect(page).to have_content(@task.due_date.to_s) 
    expect(page).to have_content(@task.category.name) 
  end

  # User Story 7: check if task can be deleted
  it "allows a user to delete a task" do
    visit edit_category_task_path(@category, @task)
    
    expect(page).to have_content("A test task")
  
    find("button.delete-button").click
    
    expect(page).not_to have_content("A test task")
    expect(page).to have_content("Task deleted successfully") 
  end

  #User Story 8 check if today’s tasks can be filtered
  it "displays only today's tasks in the 'Due Today' section" do
    @task_today = Task.create!(description: "Task due today", 
                               due_date: Date.today, 
                               category: @category)
    
    visit all_tasks_categories_path

    expect(page).to have_content("Due Today")
    expect(page).to have_content("Task due today")
  end
  
  # User Story 9 create a test user
  it "allows a user to sign up successfully" do
    visit new_user_path

    fill_in "Email", with: "newuser@example.com"
    fill_in "password", with: "password"
    fill_in "user[password_confirmation]", with: "password"

    click_button "Sign Up"

    expect(page).to have_content("Successfully signed up!")
    expect(page).to have_content("Logout")
  end

  # User Story 10 log in the test user
  it "logs in the created user successfully" do
    visit logout_path if defined?(logout_path)
  
    visit login_path

    fill_in "email", with: "test@example.com"
    fill_in "password", with: "password"
    click_button "Login"
  
    expect(page).to have_content("Logged in successfully!")
    expect(page).to have_content("Logout")
  end
  
  
end
