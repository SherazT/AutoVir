Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#home'
  get 'about' => 'static_pages#about'
  get 'help' => 'static_pages#help'
  get 'contact' => 'static_pages#contact'
  get 'terms' => 'static_pages#terms'
  post 'dashboard' => 'static_pages#dashboard'
  get 'dashboard' => 'static_pages#dashboard'
  # twitter
  post 'twitter_follow' => 'twitter_follows#follow'
  post 'twitter_summary' => 'twitter_follows#post_tweet'
  post 'twitter_retweet' => 'twitter_follows#retweet'
end
