Rails.application.routes.draw do
  get "users/show"
  get '/profile', to: 'users#show', as: 'user_profile'
  get "/disclaimer", to: "disclaimers#new"
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }, skip: [:sessions]

  # get '/disclaimer', to: 'disclaimers#new', as: :disclaimer

  get '/legal_disclaimer', to: 'disclaimers#legal', as: :legal_disclaimer
  post '/legal_disclaimer/accept', to: 'disclaimers#accept_legal', as: :accept_legal_disclaimer

  resources :disclaimers

  devise_scope :user do  
    get '/users/sign_in', to: 'users/sessions#new', as: :new_user_session
    post '/users/sign_in', to: 'users/sessions#create', as: :user_session
    delete '/users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
    get '/users/sign_out', to: 'users/sessions#destroy' # Temporary
    # Move the root route here
    root to: "users/sessions#new"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "/session", to: "sessions#check"
  post "/session.user", to: "sessions#check" # Temporary route
  get "/csrf_token", to: "application#csrf_token"
 
  resources :disclaimers do
    member do
      get :download_txt
      get :download_pdf
    end
  end
end