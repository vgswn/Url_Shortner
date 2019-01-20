Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/short-url' => 'urls#short_url'
  post '/shorten-url' => 'urls#shorten_url'
end
