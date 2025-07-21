Rails.application.routes.draw do
  get "packages/index"
  get "packages/show"
  get "additional_services/index"
  get "additional_services/show"
  get "plans/index"
  get "plans/show"
  get "subscriptions/index"
  get "subscriptions/show"
  get "customers/index"
  get "customers/show"
  root "home#index"

  resources :customers
  resources :plans
  resources :additional_services
  resources :packages
  resources :subscriptions, only: [ :index, :show, :new, :create ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
