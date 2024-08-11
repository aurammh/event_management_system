Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => {  sessions: 'sessions', registrations: 'registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :events do
    post 'create_invite', to: 'invites#create'
    delete 'destroy_invite', to: 'invites#destroy'
  end

  post 'create_attending', to: 'attendings#create'
  delete 'destroy_attending', to: 'attendings#destroy'

  get 'my_events', to: 'users#show'

  # Defines the root path route ("/")
  root "events#index"

  draw :api
end
