class TwitterFollowsController < ApplicationController
  require 'CSV'

  def follow
    now = Time.now.to_s.split(" ")[0..1].join("-")
    script = Rails.root.join("lib", "external_scripts", "autovir.R")
    data = Rails.root.join("data")
    hashtag = params[:hashtag]
    recommended_csv = data + (now+"recommendations.csv")
    output = `Rscript #{script} "#{hashtag}"  "AutovirCo" "#{recommended_csv}" '#{data+(now+"scrape.csv")}' '#{data+(now+"summary.csv")}' '#{data+(now+"followers.csv")}'`
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "nVm66LX4gtPp3BQxznYIpYQ6c"
      config.consumer_secret     = "iI6rLxbYliTPkqMWN1fuNgzKcg5H62Lhq7hTwXiPBfmfm4mAjw"
      config.access_token        = "741710243311149056-AXKreZc0zJ58K0BXZNlgstB2sHd7nsx"
      config.access_token_secret = "979VeZvUbPjbCkugMAA3HKAM62iEJ37bO3fJI2YuJZa7S"
    end
    begin
      CSV.foreach(recommended_csv) do |row|
        client.follow(row[0])
      end
    rescue Twitter::Error::TooManyRequests => error
      flash[:error] = "Twitter rate limit"
    end
    flash[:success] = "Succesfully followed companies!"
    redirect_to dashboard_url
  end

  def post_tweet
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "nVm66LX4gtPp3BQxznYIpYQ6c"
      config.consumer_secret     = "iI6rLxbYliTPkqMWN1fuNgzKcg5H62Lhq7hTwXiPBfmfm4mAjw"
      config.access_token        = "741710243311149056-AXKreZc0zJ58K0BXZNlgstB2sHd7nsx"
      config.access_token_secret = "979VeZvUbPjbCkugMAA3HKAM62iEJ37bO3fJI2YuJZa7S"
    end
    r = ConceptExtraction.new(params[:link]).analyze
    tweet = r["positive"][0..2].map { |x| x["original_text"] }.join("...") + " "
    tweet += r["positive"][0..2].map { |x| "#" + x["sentiment"].tr(" ", "") }.join(" ")
    byebug
    client.update(tweet[0..139])
    flash[:success] = "The tweet has been succesfully posted: #{tweet}"
    redirect_to dashboard_url
  end

  def retweet
    now = Time.now.to_s.split(" ")[0..1].join("-")
    script = Rails.root.join("lib", "external_scripts", "autovir2.R")
    data = Rails.root.join("data")
    hashtag = params[:retweet]
    recommended_csv = data + (now+"retweet_list.csv")
    output = `Rscript #{script} "#{hashtag}"  "AutovirCo" "#{recommended_csv}" '#{data+(now+"sentiment.csv")}'`
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "nVm66LX4gtPp3BQxznYIpYQ6c"
      config.consumer_secret     = "iI6rLxbYliTPkqMWN1fuNgzKcg5H62Lhq7hTwXiPBfmfm4mAjw"
      config.access_token        = "741710243311149056-AXKreZc0zJ58K0BXZNlgstB2sHd7nsx"
      config.access_token_secret = "979VeZvUbPjbCkugMAA3HKAM62iEJ37bO3fJI2YuJZa7S"
    end
    begin
      CSV.foreach(recommended_csv) do |row|
        client.retweet(row[0])
      end
    rescue Twitter::Error::TooManyRequests => error
      flash[:error] = "Twitter rate limit"
      redirect_to dashboard_url
    end
    flash[:success] = "succesfully retweeted!"
    redirect_to dashboard_url
  end
end
