Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :customers do
        get ':id/favorite_merchants', to: 'favorite_merchants#show'
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
