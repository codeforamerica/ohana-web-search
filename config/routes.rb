Rails.application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.

  # Read more about routing: http://guides.rubyonrails.org/routing.html

  root to: 'home#index'
  resources :organizations, only: [:index]
  get 'organizations/*id/' => 'organizations#show', as: 'location'
  get '/about' => 'about#index'
  post '/feedback' => 'about#index'
  get '.well-known/status' => 'status#get_status'
end
