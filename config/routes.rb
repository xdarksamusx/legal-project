Rails.application.routes.draw do
  get "users/show"
  get '/profile', to: 'users#show', as: 'user_profile'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do  
    delete '/users/sign_out' => 'devise/sessions#destroy' # Changed to DELETE to match useAuth.tsx
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Add routes for session check and CSRF token
  get "/session", to: "sessions#check"
  get "/csrf_token", to: "sessions#csrf_token"

  root "disclaimers#new"

  resources :disclaimers do
    member do
      get :download_txt
      get :download_pdf
    end
  end
end