Rails.application.routes.draw do
  resources :tasks, except: [:index]
  root to: 'tasks#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
