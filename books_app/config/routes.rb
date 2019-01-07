# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: "users/confirmation",
    passwords:     "users/passwords",
    registrations: "users/registrations",
    sessions:      "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks",
    }
  root to: "books#index"
  resources :books
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
