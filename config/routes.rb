Rails.application.routes.draw do
  resources :invitations, controller: 'rails_jwt_auth/invitations', only: %i[create update]
  resources :passwords, controller: 'rails_jwt_auth/passwords', only: %i[create update]
  resources :confirmations, controller: 'rails_jwt_auth/confirmations', only: %i[create update]
  resources :registration, controller: 'registrations', only: %i[create update destroy]
  resources :session, controller: 'rails_jwt_auth/sessions', only: %i[create destroy]
  resources :comments
  resources :posts
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
