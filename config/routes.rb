Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  get 'urls/short_to_long'
  get 'urls/long_to_short'
  get 'urls/show'
  post 'urls/ShowShorten' => 'urls#show_shorten'
  post'urls/ShowShort' => 'urls#show_short'
  devise_for :users
  devise_for :views
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/short-url' => 'urls#short_url'
  post '/shorten-url' => 'urls#shorten_url'
end
