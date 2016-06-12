
args <- commandArgs(trailingOnly = TRUE)

input <- args[1]
client_username <- args[2]

library(twitteR)
library(stringr)
library(dplyr)

## twitter api keys/tokens/secrets
CONSUMER_KEY = 'nVm66LX4gtPp3BQxznYIpYQ6c'
CONSUMER_SECRET = 'iI6rLxbYliTPkqMWN1fuNgzKcg5H62Lhq7hTwXiPBfmfm4mAjw'
OAUTH_TOKEN = '741710243311149056-AXKreZc0zJ58K0BXZNlgstB2sHd7nsx'
OAUTH_TOKEN_SECRET = '979VeZvUbPjbCkugMAA3HKAM62iEJ37bO3fJI2YuJZa7S'
	
auth<-setup_twitter_oauth(CONSUMER_KEY, CONSUMER_SECRET,OAUTH_TOKEN, OAUTH_TOKEN_SECRET)

token <- get("oauth_token", twitteR:::oauth_cache) 
#Save the credentials info
token$cache()

#records rate limit for different 
rate.limit<-getCurRateLimitInfo(c("lists"))

scrape<-searchTwitter(input,n=150,lang="en")
tweet_summary <- twListToDF(scrape)

fo<-paste(unique(tweet_summary$text),collapse=' ')

library(havenondemand)
client <- HODClient(apikey = "2e6b3b53-5e41-497d-aab1-e1a05d90bc33", version = "v1")
r<-client$postRequest(params = list(text = fo), hodApp = HODApp$SENTIMENT_ANALYSIS, mode = HODClientConstants$REQUEST_MODE$SYNC)

pos<-{};for(i in 1:length(r$positive)){pos[[i]]<-data.frame(t(unlist(r$positive[[i]])))};pos_sent<-data.frame(sentiment="positive",plyr::rbind.fill(pos))
neg<-{};for(i in 1:length(r$negative)){neg[[i]]<-data.frame(t(unlist(r$negative[[i]])))};neg_sent<-data.frame(sentiment="negative",plyr::rbind.fill(neg))

total_sent<-rbind(pos_sent,neg_sent)
retweet_list<-tweet_summary[rev(order(tweet_summary$retweetCount)),c("id","retweetCount","text")]
retweet_list<-retweet_list[!duplicated(retweet_list$retweetCount),]

write.table(retweet_list[,1],args[3],row.names=F,col.names=F,sep=",")
write.csv(total_sent,args[4],row.names=F)
