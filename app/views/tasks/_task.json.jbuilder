json.extract! task, :id, :title, :description, :due_date, :completed, :category_id, :created_at, :updated_at
json.url task_url(task, format: :json)
