HumanServicesFinder::Application.routes.draw do
  root :to => "home#index"
  resources :organizations
  get "/about" => "about#index"
end
