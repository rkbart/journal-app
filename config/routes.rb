Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/logout", to: "sessions#destroy"


  resources :users

  resources :categories do
    resources :tasks, only: [:index, :new, :create, :edit, :update, :destroy, :show]
    get 'all_tasks', on: :collection # Custom route to show all tasks
  end

  root 'categories#index'
  # root 'sessions#new'
end
