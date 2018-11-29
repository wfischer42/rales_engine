Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/most_revenue', to: 'merchants#index'

      resources :merchants, only: [:index, :show]
    end
  end
end
