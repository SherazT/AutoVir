

args <- commandArgs(trailingOnly = TRUE)


input <- args[1]
client_username <- args[2]

#input <- "#foodie"
#client_username <- "seanmccrdy"

library(twitteR)
library(stringr)
library(dplyr)

ZMAD<-function(data.frame) {
	(data.frame-median(data.frame,na.rm=T))/median(abs(data.frame-median(data.frame,na.rm=T)),na.rm=T)
}

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

scrape<-searchTwitter(input,n=500,lang="en")
tweet_summary <- twListToDF(scrape)


#### collects user data

user_data_raw<-lookupUsers(tweet_summary$screenName)
user_data_clean<-{}

for (i in 1:nrow(tweet_summary)){
user<-tweet_summary$screenName[i]
user_data_clean[[i]]<-data.frame(user,
user_data_raw[[user]][["description"]],
user_data_raw[[user]][["statusesCount"]],
user_data_raw[[user]][["followersCount"]],
user_data_raw[[user]][["favoritesCount"]],
user_data_raw[[user]][["friendsCount"]])}

user_data_clean <-do.call("rbind",user_data_clean)
names(user_data_clean) <-c("screenName","description","statusesCount","followersCount","favoritesCount","friendsCount")

final<-user_data_clean %>% mutate(ff_ratio= followersCount/friendsCount, norm_ff_ratio=ZMAD(log(ff_ratio)))  %>% plyr::join(tweet_summary,by="screenName",type="inner")
final<-final[!duplicated(final),]
final$statusSource<-gsub("twitter.com/#!/download/","",gsub("twitter.com/download/","",gsub("\"","",gsub("href=\"https://","",gsub("href=\"http://","",str_split_fixed(final$statusSource," ",3)[,2])))))

final<-final[!duplicated(final[,1:2]),]


self_followers<-data.frame("type"="followers",t(sapply(getUser(client_username)$getFollowers(), function(x) c(x$screenName, x$location, x$statusesCount))))

self_friends<-data.frame("type"="following",t(sapply(getUser(client_username)$getFriends(), function(x) c(x$screenName, x$location, x$statusesCount))))

final["following_client"]<-ifelse(final$screenName %in% self_followers$X1,1,0)

write.table(final[abs(1-final$ff_ratio)<0.2,"screenName"],"recommended_users.csv",row.names=FALSE,col.names=FALSE,sep=",")


write.csv(final,"final_scrape.csv")