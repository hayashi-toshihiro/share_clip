Rails.application.routes.draw do
  get 'test', to: 'test#new'

  resources :users, only: %i[new create]
  resources :clip_posts
  resources :like, only: %i[create destroy]

  get 'terms', to: 'satatic_pages#terms'
  get 'privacy_policy', to: 'satatic_pages#privacy_policy'

  get 'contact', to: 'contacts#new'
  post 'contact', to: 'cotacts#create'
  get 'contact/success', to: 'contacts#success'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
