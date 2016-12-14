Rails.application.routes.draw do
  resources :contacts
  resources :slides
  resources :comments
  resources :messages
  resources :shares
  mount ActionCable.server => '/cable'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions'
  # }
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
    #get "/signup" => "devise/registrations#new"
  end
  resources :decks

  post :google_analytics_website_stats, to: 'contacts#google_analytics_website_stats'
  get :google, to: 'contacts#google'
  post :annotations, to: 'slides#create_annotation'
  get :hello_world, to: 'hello_world#index'
  get :signup, to: 'home#signup'
  root to: "home#index"
end
