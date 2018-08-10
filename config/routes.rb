# frozen_string_literal: true

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController

  resources :users, only: [:show]
  resources :charges

  get '/landing', to: 'pages#landing'
  root to: "pages#home"
end
