class UserAcquisition < ActiveRecord::Base
  def create
  end

client = Twitter::REST::Client.new do |config|
   config.consumer_key        = "nVm66LX4gtPp3BQxznYIpYQ6c"
   config.consumer_secret     = "iI6rLxbYliTPkqMWN1fuNgzKcg5H62Lhq7hTwXiPBfmfm4mAjw"
   config.access_token        = "741710243311149056-AXKreZc0zJ58K0BXZNlgstB2sHd7nsx"
   config.access_token_secret = "979VeZvUbPjbCkugMAA3HKAM62iEJ37bO3fJI2YuJZa7S"
 end
end
