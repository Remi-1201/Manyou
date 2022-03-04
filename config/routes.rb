Rails.application.routes.draw do
    root 'tasks#index'
    resources :sessions, only: [:new, :create, :destroy]
    resources :users, only: [:new, :create, :show, :edit, :update, :index]
    resources :tasks do
      collection do
        post :sort
        get :search
    end
  end
end
