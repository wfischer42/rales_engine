Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get 'most_revenue', to: 'most_revenue#index'
        get 'most_items', to: 'most_items#index'
        get 'revenue', to: 'revenue#show'
      end
      resources :merchants, only: [:index, :show]
    end
  end
end
