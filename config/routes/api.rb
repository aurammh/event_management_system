# frozen_string_literal: true

namespace :api do
  namespace :v1 do
    devise_scope :user do
      post 'sign_up', to: 'registrations#create'
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'
    end

    resources :events
  end
end
