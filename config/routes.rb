Rails.application.routes.draw do
  resources :accounts

  resources :punch_clocks do
    resources :employees
  end

  resources :jobbers

  resources :entrances

  resources :employees do
    collection do
      get 'month_list'
    end
    member do
      get 'last_seen'
    end
    resources :entrances
  end

  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users
  resources :users

end
