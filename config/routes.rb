Rails.application.routes.draw do
  resources :employees do
    member do
      get 'last_seen'
    end
  end
  
  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
