Rails.application.routes.draw do
  root 'tasks#index'
    resources :tasks do
    collection do
      post :sort
    end
  end
end
