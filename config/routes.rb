HumanServicesFinder::Application.routes.draw do
  root :to => "home#index"
  resources :organizations
  resources :about
end
