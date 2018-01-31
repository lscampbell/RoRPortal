Rails.application.routes.draw do

  
  resources :customers, only: [:index] do
    resources :supply_points, only: [:index] do
      resources :view_charge_requests, only: [:new, :create]
      resources :charges, only: [:index] do
        collection do
          get :clock
        end
      end
    end
    resources :consumptions, only: [:index]
  end

  root to: 'home#index'
end
