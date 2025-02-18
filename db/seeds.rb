# db/seeds.rb
user = User.find_or_create_by!(email: 'rk_bart@yahoo.com') do |u|
    u.password = 'password123'
    u.username = 'Test User'
  end
Category.find_or_create_by!(name: "Uncategorized", user: user)
Category.find_or_create_by!(name: "Work", user: user)
Category.find_or_create_by!(name: "Personal", user: user)

work_category = Category.find_by(name: "Work")
Task.create!(title: "Sample Task", description: "A test task", due_date: Date.today, completed: false, category: work_category)
