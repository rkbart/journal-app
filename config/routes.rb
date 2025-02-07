Rails.application.routes.draw do
  
  resources :categories do
    resources :tasks, only: [:index, :new, :create, :edit, :update]
  end

  root 'categories#index'
end
