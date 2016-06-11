Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#home'
  get 'about' => 'static_pages#about'
  get 'help' => 'static_pages#help'
  get 'contact' => 'static_pages#contact'
  get 'terms' => 'static_pages#terms'

  # twitter
  get 'twitter-connect' => "twitter_connections#create"
  get 'twitter-callback' => "twitter_connections#callback"
end
