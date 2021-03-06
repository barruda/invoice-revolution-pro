# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: :create
  resources :invoices, param: :invoice_id do
    get :scanned, on: :member
  end
  resources :chargebacks, only: :create

  get '/invoices/:invoice_id/:status', to: 'invoices#index'
  put '/invoices/:invoice_id/pay', to: 'transactions#pay'
  put '/invoices/:invoice_id/invalidate', to: 'transactions#invalidate'

  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found',
             constraints: ->(request) { !request.path_parameters[:a].start_with?('rails/') }
end
