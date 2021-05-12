Rails.application.routes.draw do
  resources :tasks, except: [:index] do
    resources :complete, only: [:create]

    collection do
      resources :complete_all, only: [:create]
      resources :clear_complete, only: [:create]
    end
  end
  resources :active, only: [:index]
  resources :completed, only: [:index]
  root to: 'tasks#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
