Rails.application.routes.draw do
  resources :slides
  resources :comments
  resources :messages
  resources :shares
  mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
    get "/signup" => "devise/registrations#new"
  end
  resources :decks


  get :hello_world, to: 'hello_world#index'
  root to: "home#index"
end
