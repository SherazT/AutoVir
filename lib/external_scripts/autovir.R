
args <- commandArgs(trailingOnly = TRUE)

input <- args[1]
client_username <- args[2]

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

scrape<-searchTwitter(input,n=200,lang="en")
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
final["pull_date"]<-date()

self<-getUser(client_username)
self_followers<-data.frame("type"="followers",t(sapply(self$getFollowers(), function(x) c(x$screenName, x$location, x$statusesCount))))
self_friends<-data.frame("type"="following",t(sapply(self$getFriends(), function(x) c(x$screenName, x$location, x$statusesCount))))

self_summary<-data.frame(self$screenName,
self$statusesCount,
self$followersCount,
self$favoritesCount,
self$friendsCount) 
names(self_summary) <-c("screenName","statusesCount","followersCount","favoritesCount","friendsCount")

self_summary["reciprocal"] = length(base::intersect(self_followers$X1,self_friends$X1))
self_summary["disciples"] = length(base::setdiff(self_followers$X1,self_friends$X1))
self_summary["messiahs"] = length(base::setdiff(self_friends$X1,self_followers$X1))
self_summary <-self_summary %>% mutate(ff_ratio = followersCount/friendsCount)
self_summary["pull_date"]<-date()

final["following_client"]<-ifelse(final$screenName %in% self_followers$X1,1,0)

self_followers_info<-self$getFollowers()
self_followers_info_final<-{}
for (i in 1:nrow(self_followers))
{
self_followers_info_final[[i]]<-data.frame(self_followers_info[[i]][["screenName"]],
self_followers_info[[i]][["description"]],
self_followers_info[[i]][["location"]],
self_followers_info[[i]][["statusesCount"]],
self_followers_info[[i]][["followersCount"]],
self_followers_info[[i]][["favoritesCount"]],
self_followers_info[[i]][["friendsCount"]],date())
}
self_followers_info_final<-do.call("rbind",self_followers_info_final)
names(self_followers_info_final) <-c("screenName","description","location","statusesCount","followersCount","favoritesCount","friendsCount","pull_date")


write.table(final[abs(1-final$ff_ratio)<0.2,"screenName"],args[3],row.names=FALSE,col.names=FALSE,sep=",")
write.csv(final,args[4],row.names=FALSE)
write.csv(self_summary,args[5],row.names=FALSE)
write.csv(self_followers_info_final,args[6],row.names=FALSE)
