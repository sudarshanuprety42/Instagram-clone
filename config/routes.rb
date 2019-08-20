Rails.application.routes.draw do
  get 'instagram/index'
  get 'instagram/currentuser'
  get 'instagram/edit_profile'
  post 'instagram/update_profile'
  get 'instagram/edit_password'
  post 'instagram/update_password'
  post 'instagram/update_dp'
  get 'instagram/search_user'


  get '/instagram/follow/:id', to: 'instagram#follow'
  get '/instagram/show_user/:id', to: 'instagram#show_user'
  get '/instagram/followers/:id', to: 'instagram#followers'
  get '/instagram/followings/:id', to: 'instagram#followings'

  devise_for :users
  root 'instagram#index'

  resources :posts

  resources :posts do
    resources :comments
  end

  # resources :posts, only: [ :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
