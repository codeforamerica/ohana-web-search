HumanServicesFinder::Application.routes.draw do
  root :to => "home#index"
  resources :organizations, :only => [:show, :index]
  get "/about" => "about#index"
  post "/feedback" => "about#index"
end
