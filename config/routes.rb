Rails.application.routes.draw do
  namespace :api do
    api_version(module: "v1", path: {value: "v1"}) do
      resources :transactions, only: [:index, :show, :create]
      resources :balances, only: :index
    end
  end
end
