# frozen_string_literal: true

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController

  resources :users, only: [:show]
  resources :charges

  get '/thankyou', to: 'pages#offer'
  get '/landing', to: 'pages#landing'
  root to: "pages#index"
end
