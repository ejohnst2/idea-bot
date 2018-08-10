# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'
  telegram_webhook TelegramWebhooksController

  resources :users, only: [:show]
  resources :charges

  root to: "pages#home"
end
