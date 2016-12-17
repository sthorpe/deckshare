Rails.application.routes.draw do
  resources :questions, only: [:new, :index, :create, :show, :edit, :destroy, :answer_questions] do
    resources :answers
  end
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
  mount Facebook::Messenger::Server, at: 'bot'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end
  resources :decks

  post :google_analytics_website_stats, to: 'contacts#google_analytics_website_stats'
  get :google, to: 'contacts#google'
  post :annotations, to: 'slides#create_annotation'
  get :hello_world, to: 'hello_world#index'
  get :answer_questions, to: 'questions#answer_questions'
  get :send_message_to_fb_user, to: 'contacts#send_message_to_fb_user'
  get :receive_message_from_fb, to: 'contacts#receive_message_from_fb'
  match :webhook, to: 'webhook#bot', as: :webhook, via: [:get, :post]
  get :signup, to: 'home#signup'
  root to: "home#index"
end
