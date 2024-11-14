Rails.application.routes.draw do
  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
             controllers: {
               sessions: "users/sessions",
               registrations: "users/registrations",
               passwords: "users/passwords",
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
      get :top_three_users, path: "top-three"
      get :leaderboards, path: "all"
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
      get :current_user_sent_friend_requests
      get :current_user_received_friend_requests
      delete :decline_friend_request
      get :find_friend
    end
  end

  # categories routes
  resources :categories

  # sub_categories routes
  resources :sub_categories, only: [:index] do
    collection do
      get :top_sub_categories
    end
  end

  # settings routes
  resources :settings, only: [:index] do
    collection do
      patch :update_settings
    end
  end

  # sub category follower routes
  resources :sub_category_followers, only: [] do
    collection do
      post :follow
      delete :unfollow
    end
  end

  # otp routes
  namespace :users do
    resources :confirmations, only: [] do
      collection do
        post :validate_otp
        post :resend_otp
      end
    end
  end

  # sub category leaderboard routes
  resources :sub_category_leaderboards

  # user profile infos routes
  resources :user_profile_infos

  # sub category quizzes routes
  resources :sub_category_quizzes, only: [:index] do
    collection do
      post :answer
    end
  end
end
