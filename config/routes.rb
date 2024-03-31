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

  # Admin stuff
  patch '/admin/roles', to: 'admin/roles#set_user_role'
  get '/admin/users', to: 'admin/users#list_users'
end
