Rails.application.routes.draw do
  
  resources :categories do
    resources :tasks, only: [:index, :new, :create, :edit, :update, :destroy, :show]
    get 'all_tasks', on: :collection # Custom route to show all tasks
  end

  root 'categories#index'
end
