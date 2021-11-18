Rails.application.routes.draw do
  root to: 'users#index'

  resources :users, except: [:destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :questions, except: [:show, :new, :index]
  get 'show' => 'users#show'

  get 'sign_up' => 'users#new'
  get 'log_out' => 'sessions#destroy'
  get 'log_in' => 'sessions#new'

end
