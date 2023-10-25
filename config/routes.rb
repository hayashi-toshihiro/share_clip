Rails.application.routes.draw do
  root to: "clip_posts#index"

  # Test Controller
  get 'test', to: 'test#new'

  # Clip Posts
  resources :clip_posts do
    resources :comments, shallow: true, only: %i[create destroy]
    collection do
      get :likes
      get :get_clip
      get :update_video
    end
  end

  # Tags
  resources :tags do
    collection do
      get :auto_complete_streamers
      get :auto_complete_tags
    end
  end

  # Users
  resources :users, only: %i[new create] do
    collection do
      get :get_user_stamp
    end
  end

  # Likes and Comment Likes
  resources :likes, only: %i[create destroy]
  resources :comment_likes, only: %i[create destroy]

  # Static Pages
  get 'terms', to: 'satatic_pages#terms'
  get 'privacy_policy', to: 'satatic_pages#privacy_policy'

  # Contacts
  get 'contact', to: 'contacts#new'
  post 'contact', to: 'contacts#create'
  get 'contact/success', to: 'contacts#success'

  # User Sessions
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy', as: :logout
end
