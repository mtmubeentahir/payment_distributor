Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => '/sidekiq'

  resources :orders
  resources :merchants
  resources :disbursments, only: [:index]

  get 'disbursment/process_orders', to: "disbursments#process_orders", as: 'process_orders'

  root "disbursments#index"
end
