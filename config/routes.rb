Rails.application.routes.draw do
  resources :posts
  root "posts#index"  # <==== Add this
end
