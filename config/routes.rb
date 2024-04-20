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

  # Admin stuff
  patch '/admin/roles', to: 'admin/roles#set_user_role'
  get '/admin/users', to: 'admin/users#list_users'
  post '/admin/users/terminate', to: 'admin/users#terminate_user'
  post '/admin/users/restore', to: 'admin/users#restore_user'


end
