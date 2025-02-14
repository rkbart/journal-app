require 'rails_helper'

RSpec.describe "Categories Index", type: :feature do
  before(:each) do
    # User Story 9 create a test user
    @user = User.create!(username: "testuser", email: "test@example.com", password: "password")
    
    # User Story 10 log in the test user
    visit login_path
    fill_in "email", with: "test@example.com"
    fill_in "password", with: "password"
    click_button "Login"

    # Ensure "Uncategorized" category exists
    @uncategorized = Category.find_or_create_by!(name: "Uncategorized", user: @user)
    @category = Category.create!(name: "Work", user: @user)
    @task = Task.create!(title: "Sample Task", description: "A test task", due_date: Date.today, completed: false, category: @category)
  end

  #User Story 3 view all categories
  it "displays the categories list" do
    visit categories_path
    expect(page).to have_content("Categories")
    expect(page).to have_content("Work")
  end

  it "ensures 'Uncategorized' category is always present" do
    visit categories_path
    expect(page).to have_content("Uncategorized")
  end

  #User Story 1 create a new category 
  let!(:category) { Category.create(name: "Old Name", user: @user) } # Create a sample category for updating

  it "allows a user to create a new category" do
    visit new_category_path
    fill_in "category_name", with: "Personal" # Ensure this matches the actual field name in your form
    click_button "Create Category"

    expect(page).to have_content("Category created successfully.")
    # expect(Category.count).to eq(5) 
  end

  #User Story #2 update a category
  it "allows a user to update a category" do
    visit edit_category_path(category)

    fill_in "category_name", with: "Updated Name" # Ensure this matches the actual field name
    click_button "Update Category"

    expect(page).to have_content("Category updated successfully.")
    expect(page).to have_content("Updated Name")
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
  
  
  #User Story #4 create a task inside a category
  it "allows a user to create a new task within a category" do
    # Navigate to the 'new task' form for the category
    visit new_category_task_path(@category)
  
    # Fill in the form with task details
    fill_in "task_description", with: "This is a task description"
    fill_in "task_due_date", with: "2025-12-31" # Ensure field names match the form
    click_button "Save Task"
  
    # Expectations to verify the task was created successfully
    expect(page).to have_content("Task created successfully.") # Ensure success message is shown
    
  end

  # User Story #5: Update a task within a category
  it "allows a user to update a task within a category" do
    # Navigate to the edit task form for an existing task
    visit edit_category_task_path(@category, @task)

    # Fill in the form with updated task details
    fill_in "task_description", with: "Updated task description"
    fill_in "task_due_date", with: "2026-01-01" # Ensure field names match the form

    # Submit the form
    click_button "Save Task"

    # Expectations to verify the task was updated successfully
    expect(page).to have_content("Task updated successfully.") # Ensure success message is shown
    expect(page).to have_content("2026-01-01")                 # Check if the new due date is displayed
  end

   #User Story 6 ensure task details can be viewed.
   it "displays the all tasks list" do
    visit all_tasks_categories_path

    expect(page).to have_content("All Tasks")

    expect(page).to have_content(@task.description) # Check for the task description
    expect(page).to have_content(@task.due_date.to_s) # Ensure the due date is shown
    expect(page).to have_content(@task.category.name) # Ensure the category is displayed
  end

  # User Story 7: check if task can be deleted
  it "allows a user to delete a task" do
    # Visit the category's tasks page
    visit edit_category_task_path(@category, @task)

    # Ensure the task is displayed before deletion
    expect(page).to have_content("A test task")

    # Click the delete button
        find("button.delete-button").click
    
    # Verify the task is no longer displayed on the page
    expect(page).not_to have_content("A test task")
    expect(page).to have_content("Task deleted successfully") # Adjust the text if your flash message differs
  end

  #User Story 8 check if today’s tasks can be filtered

  it "displays only today's tasks in the 'Due Today' section" do
    # Create tasks with different due dates
    @task_today = Task.create!(description: "Task due today", due_date: Date.today, category: @category)
    
    # Visit the "All Tasks" page
    visit all_tasks_categories_path

    # Check for the "Due Today" section and ensure it only contains the task due today
    expect(page).to have_content("Due Today")
    expect(page).to have_content("Task due today")
    
  end

end
