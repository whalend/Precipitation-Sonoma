#---
# Rain gauge data summary and manipulation
# Goal: summarize precipitation events into hourly and daily, and convert to inches
# Conversion factor: 1 event = 0.01 inches
#---

setwd("P:/geospatial/Research/rkmeente/Workspaces/wwdillon/soco_ppt")
library(plyr)
library(data.table)
library(dplyr)
library(tidyr)




make_database <- function(x){
#       
#       fnames <- sub("^([^.]*).*", "\\1", basename(x))
#       gauge_names <- sub("^([^_.]*).*", "\\1", basename(x))
#       tab <- fread(x, header=TRUE, stringsAsFactors=FALSE, skip=2, drop=1)
#       tab$Date <- paste(tab[,2],tab[,3], sep=' ')
#       tab$plotid  <-  gauge_names
# #       tab <- tab[,-3]
# #       z <- data.matrix(tab$TempC)
# #       rownames(z) <- tab$Date
# #       z.zoo <- zoo(z, rownames(z))
# #       return(z.zoo)
#       
}

# rg_data2 <- ldply(files, FUN=make_database)

# a <- fread("", skip=2, drop=1)

#### Manipulations of some single files that were not correctly formatted for opening in Excel ####
# d1 <- fread("Rain_Gauge/all_years_raw_exports/SDC_502836_2007_RG.csv")
# d1 <- separate(d1, date_time, c("date", "time"), sep=" ")
# write.csv(d1, "Rain_Gauge/all_years_raw_exports/SDC_502836_2007_RG.csv")
# 
# d1 <- fread("Rain_Gauge/all_years_raw_exports/SDC_502836_2008_RG.csv")
# d1$id <- "sec"
# write.csv(d1, "Rain_Gauge/all_years_raw_exports/SDC_502836_2008_RG.csv")
# 
# d1 <- fread("Rain_Gauge/all_years_raw_exports/SUGAR_20070416_20090411_RG.csv")
# d1$id <- "sugarloaf"
# d1 <- d1 %>% separate(date_time, c("date", "time"), sep=" ") %>% 
#       select(id, date, time, events)
# write.csv(d1, "Rain_Gauge/all_years_raw_exports/SUGAR_20070416_20090411_RG.csv")
# 
# d1 <- fread("Rain_Gauge/all_years_raw_exports/YAHNG_502848_2009_RG.txt")
# names(d1)[1:2]  <- c("dt", "events")
# d1$id <- "yahng"
# d1 <- d1 %>% separate(dt, c("date", "time"), sep=" ") %>% 
#       select(id, date, time, events)
# write.csv(d1, "Rain_Gauge/all_years_raw_exports/YAHNG_502848_2009_RG.csv")
# head(d1)
# 
# d1 <- fread("Rain_Gauge/all_years_raw_exports/MITSUI_502950_2006_RG.csv")
# head(d1)
# d1$id <- "mitsui"
# write.csv(d1, "Rain_Gauge/all_years_raw_exports/MITSUI_502950_2006_RG.csv")

#### Make database by compiling all the files together ####
files <- list.files("Rain_Gauge/all_years_raw_exports", full.names=TRUE)
fnames <- sub("^([^.]*).*", "\\1", basename(files))
gauge_names <- sub("^([^_.]*).*", "\\1", basename(files))

rg_data <- ldply(files, function(i){
      fread(i, header=TRUE, stringsAsFactors=FALSE, showProgress=TRUE)
})

### Join `date` and `time` columns and convert to POSIX ####
rg_data$date_time <- paste(rg_data$date, rg_data$time, sep=" ")
rg_data$date_time <- strptime(rg_data$date_time, format="%m/%d/%Y %H:%M:%S", tz="UTC")


### Create year, month, day, and hour columns for grouping ####
rg_data$year <- year(rg_data$date_time)
rg_data$month <- month(rg_data$date_time)
rg_data$day <- mday(rg_data$date_time)
rg_data$hour <- hour(rg_data$date_time)
head(rg_data)
class(rg_data$date_time)
rg_data <- rg_data[,-5]


### Summarize into hourly data set ####
hourly_rain <- rg_data %>% 
      select(id, date, year, month, day, hour, events) %>% 
      group_by(id, year, month, day, hour) %>%
      filter(year<=2014 & month<=5) %>%
      summarize(hourly_events=length(events), hourly_ppt=length(events)*0.01)
#hourly$hourly_ppt <- hourly$hourly_events * 0.01
head(hourly_rain)
hourly_rain <- data.table(hourly_rain)
class(hourly_rain)

# d <- as.IDate("2003-05-01")
# t <- as.ITime("23:00:00", format="%H:%M:%S")
# as.POSIXct("2001-05-01") + t
datetime <- rep(seq(as.POSIXct("2003-05-01 00:00:00", tz="UTC"), as.POSIXct("2014-04-30 23:59:59", tz="UTC"), by="1 hour"), each=15)

dt <- data.table(IDateTime(datetime))
dt$hour <- hour(dt$itime)
dt$day <- mday(dt$idate)
dt$month <- month(dt$idate)
dt$year <- year(dt$idate)
dt 

rm(datetime)

# seqdates <- seq(as.IDate("2003-05-01"), as.IDate("2014-04-30"), by="1 hour")

rg_dt <- data.table(rg_data$id, rg_data$events, rg_data$year, rg_data$month, rg_data$day, rg_data$hour)

rg_dt

# rg_dt <- cbind(rg_dt, IDateTime(rg_dt$V3))
# rg_dt$hour <- hour(rg_dt$itime)
# rg_dt <- select(rg_dt, -itime)

setnames(rg_dt, 1:6,c("id","events","year","month","day","hour"))


# join.keys(dt,rg_dt,by=c("idate","hour"))

rg_dt2 <- inner_join(dt, hourly_rain,by=c("year","month","day","hour"))
#summary(na.omit(rg_dt))
rg_dt2
tail(rg_dt2)
#keycols <- c("idate","hour")
#setkeyv(rg_dt, keycols)
#setkey(rg_dt, hour)
#rg_dt <- merge(dt, rg_dt, by=c("idate","hour"))



### Join `hourly_rain` data to `mc_data` by year, month, day, hour ####
tables()
mc_rg <- mc_data[hourly_rain]

#####
monthly <- d1 %>% select(plotid, year, month, events) %>% 
      group_by(plotid, year, month) %>% 
      summarize(monthly_events=length(events))
monthly$monthly_ppt <- monthly$monthly_events * 0.01
head(monthly)

daily <- d1 %>% select(plotid, year, month, day, events) %>% 
      group_by(plotid, year, month, day) %>% 
      summarize(daily_events=length(events))
daily$daily_ppt <- daily$daily_events * 0.01
head(daily)



plot(hourly$hour, hourly$hourly_ppt)


d2 <- d1 %>% select(date_time, year, month, day, hour, events) %>% 
      group_by(year, month, day, hour) %>% 
      summarize(hourly_events=length(events))
hourly$hourly_ppt <- hourly$hourly_events * 0.01
plot(d1$date_time, d1$events)


### Re-order by formatted data column ####
rg_data <- rg_data[order(as.Date(rg_data$date_time, format="%Y-%m-%d %H:%M:%S")),]


rg_data %>% select(-V1) %>% group_by(id)

class(rg_data$date_time)
head(rg_data)

### Rename columns ####
names(rg_dt)[1:3] <- c("id","events","date_time")



