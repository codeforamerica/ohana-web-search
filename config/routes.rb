HumanServicesFinder::Application.routes.draw do
  root :to => "home#index"
  get "/organizations/" => "organizations#index"
  get "/organizations/:id" => "organizations#show"
  get "/about" => "about#index"
end
