class TwitterConnectionsController < ApplicationController
  OAUTH_CONFIRM_URL = request.domain + "twitter-callback"

  def create
    request_token = client.request_token(:oauth_callback => OAUTH_CONFIRM_URL)
  end

  def callback
    redirect_to root_url
  end

  def destroy
  end

  private

  def client
    TwitterOAuth::Client.new(
      :consumer_key => ENV["twitter_consumer_key"],
      :consumer_key => ENV["twitter_consumer_secret"],
    )
  end
end
