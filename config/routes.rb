# frozen_string_literal: true
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :user, only: [:new, :create, :show]
  resource :session, only: [:new, :create, :destroy]
  root to: redirect('/session/new')

  resources :user do
    resources :events
  end
end
