Rails.application.routes.draw do
  root to: 'users#index'

  resources :users
  resources :sessions, only: [:new, :create, :destroy] #перечисляем только те экшены которые наш ресурс будет поддерживать
  resources :questions, except: [:show, :new, :index] #except говорит каких экшенов не будет в ресурсе user

  get 'sign_up' => 'users#new' #по этим путям во вьюхах через
  get 'log_out' => 'sessions#destroy' #link_to будем переходить
  get 'log_in' => 'sessions#new'#по нужному урлу. Смотри application.html.erb
end
