Rails.application.routes.draw do
  # Session routes
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/logout", to: "sessions#destroy"

  # User routes
  resources :users

  # Category and Task routes
  resources :categories do
    resources :tasks do
      member do
        patch :toggle_complete  # Adds route for marking tasks as done
      end
    end
    get 'all_tasks', on: :collection # Custom route to show all tasks
  end

  # Root route
  # root 'categories#index'
  root 'sessions#new'
end
