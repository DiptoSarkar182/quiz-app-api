Rails.application.routes.draw do
  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
             controllers: {
               sessions: "users/sessions",
               registrations: "users/registrations"
             }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: "rails/health#show"
  
  # leaderboards routes
  resources :leaderboards, only: [] do
    collection do
      get :monthly_top_three_users
      get :monthly_leaderboards
      get :weekly_top_three_users
      get :weekly_leaderboards
      get :daily_top_three_users
      get :daily_leaderboards
    end
  end

  # friend lists routes
  resources :friend_lists, only: [:index] do
    collection do
      post :add_friend
      delete :remove_friend
    end
  end

  # friend requests routes
  resources :friend_requests, only: [] do
    collection do
      post :send_friend_request
      delete :cancel_friend_request
    end
  end
end
