Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants#find'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end

      # get 'items/find', to: 'items#find'
      get 'items/find_all', to: 'items#find_all'
      resources :items do
        resource :merchant, only: [:show]
      end

      get 'revenue', to: 'revenue#date_range_revenue'
      get 'revenue/weekly', to: 'revenue#weekly_revenue'
    end
  end
end
