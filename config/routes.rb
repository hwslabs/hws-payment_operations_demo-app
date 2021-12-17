# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'application#index'

  resources :virtual_accounts, only: %I[create show] do
    member do
      post :activate
      post :deactivate
      post :transfer
      get  :balance
      # get '/transactions/:reference_number' => 'virtual_accounts#fetch_status'
    end
  end

  resources :transactions, only: :show do
    get :fetch_status
  end

  get '/health', to: proc { [200, {}, ['success']] }
end
