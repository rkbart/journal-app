Rails.application.routes.draw do
  # root 'tasks#index'

  resources :categories 
    resources :tasks
  
  get '/signup', to: 'users#new', as: 'signup'
  
end
