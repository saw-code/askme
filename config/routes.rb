Rails.application.routes.draw do
  root to: 'users#index'

  resources :users
  resources :questions
  get 'show' => 'users#show'
end
