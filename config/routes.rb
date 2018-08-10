# frozen_string_literal: true

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController

  resources :users, only: [:show]
  resources :charges

  get '/index', to: 'pages#index'
  get '/landing', to: 'pages#index'
  root to: "pages#home"
end
