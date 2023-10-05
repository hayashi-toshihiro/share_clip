Rails.application.routes.draw do
  root to: "clip_posts#index"
  get 'test', to: 'test#new'
  get 'clip_posts/get_clip', to: 'clip_posts#get_clip'
  get 'get_user_stamp', to: 'users#get_user_stamp'
  get 'tags', to: 'tags#index'
  get 'sitemap', to: redirect("https://s3-ap-northeast-1.amazonaws.com/clipreactor/sitemaps/sitemap.xml.gz")

  resources :users, only: %i[new create]
  resources :clip_posts do
    resources :comments, shallow: true, only: %i[create destroy]
    collection do
      get :likes
    end
  end

  resources :likes, only: %i[create destroy]
  resources :comment_likes, only: %i[create destroy]

  get 'terms', to: 'satatic_pages#terms'
  get 'privacy_policy', to: 'satatic_pages#privacy_policy'

  get 'contact', to: 'contacts#new'
  post 'contact', to: 'contacts#create'
  get 'contact/success', to: 'contacts#success'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy', as: :logout

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
