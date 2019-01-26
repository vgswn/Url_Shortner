Rails.application.routes.draw do
  get 'domain_prefix/index'
  get 'users/login'
  get 'users/signup'
  get 'users/logout'
  get 'users/password_change'
  get 'home/index'
  root 'home#index'
  get 'urls/short_to_long'
  get 'urls/long_to_short'
  get 'urls/show'
  post 'urls/ShowShorten' => 'urls#show_shorten'
  post'urls/ShowShort' => 'urls#show_short'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/short-url' => 'urls#short_url'
  post '/shorten-url' => 'urls#shorten_url'

  post '/users/CreateUser' => 'users#create_user'
  post '/users/Login' => 'users#check_login'
  require 'sidekiq/web'  
mount Sidekiq::Web, :at => '/sidekiq'
get 'home/generate_report'
get '/urls/autocomplete' => 'urls#autocomplete'


end
