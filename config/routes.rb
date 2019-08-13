Rails.application.routes.draw do
  namespace :api do
    api_version(module: "v1", path: {value: "v1"}) do
      resource :transactions, only: [:index, :show, :create]
    end
  end
end
