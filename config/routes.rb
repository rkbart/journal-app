Rails.application.routes.draw do
  # root 'tasks#index'

  resources :categories 
    resources :tasks
  

  
end
