# db/seeds.rb
Category.find_or_create_by!(name: "Uncategorized")
Category.find_or_create_by!(name: "Work")
Category.find_or_create_by!(name: "Personal")

work_category = Category.find_by(name: "Work")
Task.create!(title: "Sample Task", description: "A test task", due_date: Date.today, completed: false, category: work_category)
