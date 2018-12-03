Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get 'items/index'
      get 'items/show'
    end
  end
  namespace :api do
    namespace :v1 do
      get 'customers/index'
      get 'customers/show'
    end
  end
  namespace :api do
    namespace :v1 do
      namespace :items do
        get 'most_revenue', to: 'most_revenue#index'
        get 'most_items', to: 'most_items#index'
        get ':id/best_day', to: 'best_day#show'
      end
      namespace :customers do
        get ':id/favorite_merchant', to: 'favorite_merchant#show'
      end
      namespace :merchants do
        get 'most_revenue', to: 'most_revenue#index'
        get 'most_items', to: 'most_items#index'
        get 'revenue', to: 'revenue#index'
        get ':id/revenue', to: 'revenue#show'
        get ':id/favorite_customer', to: 'favorite_customer#show'
        get ':id/customers_with_pending_invoices',
            to: 'customers_with_pending_invoices#index'
      end
      resources :merchants, only: [:index, :show]
    end
  end
end
