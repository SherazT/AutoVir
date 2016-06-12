setwd("Archive/")

##viz
library(reshape2)
library(plotly)

summary_files<-list.files()[grep("summary",list.files())]
temp_sink<-{};for(i in 1:length(summary_files)){temp_sink[[i]]<-read.csv(summary_files[i])};final_summary<-do.call("rbind",temp_sink)
final_summary$pull_date<-as.POSIXct(final_summary$pull_date,format="%a %b %d %H:%M:%S %Y")

mm<-melt(final_summary[,-1],id="pull_date")

setwd("../")

p <- ggplot(data = final_summary,aes(x = pull_date,y = friendsCount)) + geom_line(col="red") +geom_point(size = 2,fill="white",pch=21,col="red")+ggthemes::theme_few()+labs(col=NULL)

try(htmlwidgets::saveWidget(as.widget(ggplotly(p)), "friends.html"))

p <- ggplot(data = final_summary,aes(x = pull_date,y = followersCount)) + geom_line(col="blue") +geom_point(size = 2,fill="white",pch=21,col="blue")+ggthemes::theme_few()+labs(col=NULL)

try(htmlwidgets::saveWidget(as.widget(ggplotly(p)), "following.html"))

p <- ggplot(data = final_summary,aes(x = pull_date,y = ff_ratio)) + geom_line(col="seagreen") +geom_point(size = 2,fill="white",pch=21,col="seagreen")+ggthemes::theme_few()+labs(col=NULL)

try(htmlwidgets::saveWidget(as.widget(ggplotly(p)), "ff_ratio.html"))

