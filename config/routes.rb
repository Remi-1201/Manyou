Rails.application.routes.draw do
    root 'tasks#index'
    resources :labels
    resources :sessions, only: [:new, :create, :destroy]
    resources :users, only: [:new, :create, :show, :edit, :update, :index]
    namespace :admin do
      resources :users, except: [:show]
    end
    resources :tasks do
      collection do
        post :sort
        get :search
    end
  end
end
