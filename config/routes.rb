# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'
  resources :leads do
    patch :update, on: :collection
  end
end
