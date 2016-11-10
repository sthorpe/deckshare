Rails.application.routes.draw do
  devise_for :users
  resources :decks
  root to: "home#index"
end
