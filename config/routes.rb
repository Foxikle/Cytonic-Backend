Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup',
    confirmation: 'confirmation',
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
  }

  # Editing / user panel
  patch '/usernames/edit', to: 'users/usernames#update'
  put '/users/avatars', to: 'users/avatars#set_avatar'
  delete '/users/avatars', to: 'users/avatars#remove_avatar'

  # Reports
  post '/reports/chat', to: 'reports/chat_reports#new'

  # banners
  post '/banners', to: 'banners#create'
  get '/banners', to: 'banners#get_banner'
  delete '/banners', to: 'banners#remove_banner'

  # Admin operations
  namespace :admin do
    patch '/roles', to: 'roles#set_user_role'
    get '/users', to: 'users#list_users'
    post '/users/terminate', to: 'users#terminate_user'
    post '/users/restore', to: 'users#restore_user'
  end

  # Threads
  namespace :forums do
    resources :threads, only: [:create, :show, :index, :destroy, :update]
  end

  namespace :forums do
    resources :categories, only: [:index]
  end

  namespace :forums do
    resources :topics, only: [:show]
  end

  namespace :forums do
    resources :comments, only: [:create, :destroy, :show, :update, :index]
  end

  namespace :forums do
    resources :lock, only: [:create, :destroy]
  end

  namespace :users do
    resources :public, only: [:show]
  end

  namespace :reports do
    resources :comment, only: [:create, :index, :show, :update, :destroy]
  end

  namespace :reports do
    resources :thread, only: [:create, :index, :show, :update, :destroy]
  end

  namespace :admin do
    resources :mute, only: [:update, :destroy]
  end

end
