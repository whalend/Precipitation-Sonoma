#---
# Rain gauge data summary and manipulation
# Goal: summarize precipitation events into hourly and daily, and convert to inches
# Conversion factor: 1 event = 0.01 inches
#---

#setwd("P:/geospatial/Research/rkmeente/Workspaces/wwdillon/soco_ppt")
library(plyr)
library(data.table)
library(dplyr)
library(tidyr)

#### Download weather data from city of Santa Rosa
sr <- fread("http://web1.ci.santa-rosa.ca.us/pworks/other/weather/download%207-1-06%206-30-07.txt", skip = 1, header=TRUE)
head(sr)
summary(sr)
str(sr)
sum(sr$Rain)


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


#### Summarizing a few independent files to daily and hourly because they were not in .hobo or .dtf format. ####

library(xlsx)

badg <- read.xlsx("Rain_Gauge/all_years_raw/BADGER_669845_2004_RG_B.xlsx", 1)
head(badg)
badg$date_time2 <- strptime(badg$date_time, format = "%m/%d/%y %H:%M")
badg$year <- year(badg$date_time2)
badg$month <- month(badg$date_time2)
badg$day <- mday(badg$date_time2)
badg$hour <- hour(badg$date_time2)

badg_daily <- badg %>% 
      select(date_time, year, month, day, hour, events) %>% 
      group_by(year, month, day) %>%
      summarize(daily_events=length(events), daily_ppt=length(events)*0.01)

badg_daily$id <- "badger"
badg_daily <- select(badg_daily, id, year, month, day, daily_events, daily_ppt)
head(badg_daily)

badg_hourly <- badg %>% 
      select(date_time, year, month, day, hour, events) %>% 
      group_by(year, month, day, hour) %>%
      summarize(hourly_events=length(events), hourly_ppt=length(events)*0.01)

badg_hourly$id <- "badger"
badg_hourly <- select(badg_hourly, id, year, month, day, hour, hourly_events, hourly_ppt)
head(badg_hourly)


sec <- read.xlsx("SDC_502836_2007_RG.xls", 1)
head(sec)
sec <- select(sec, date_time = Date.Time, events = Event..Events.)
sec$date_time2 <- strptime(sec$date_time, format = "%m/%d/%y %H:%M")
sec$year <- year(sec$date_time2)
sec$month <- month(sec$date_time2)
sec$day <- mday(sec$date_time2)
sec$hour <- hour(sec$date_time2)

sec_daily <- sec %>% 
      select(date_time, year, month, day, hour, events) %>% 
      group_by(year, month, day) %>%
      summarize(daily_events=length(events), daily_ppt=length(events)*0.01)

sec_daily$id <- "sec"
sec_daily <- select(sec_daily, id, year, month, day, daily_events, daily_ppt)
head(sec_daily)

sec_hourly <- sec %>%
      select(date_time, year, month, day, hour, events) %>% 
      group_by(year, month, day, hour) %>%
      summarize(hourly_events=length(events), hourly_ppt=length(events)*0.01)

sec_hourly$id <- "sec"
sec_hourly <- select(sec_hourly, id, year, month, day, hour, hourly_events, hourly_ppt)
head(sec_hourly)


sugar <- read.xlsx("SUGAR_20070416_20090411_RG.xlsx", 1)
head(sugar)
sugar$date_time2 <- strptime(sugar$date_time, format = "%m/%d/%y %H:%M")
sugar$year <- year(sugar$date_time2)
sugar$month <- month(sugar$date_time2)
sugar$day <- mday(sugar$date_time2)
sugar$hour <- hour(sugar$date_time2)

sugar_daily <- sugar %>% 
      select(date_time, year, month, day, hour, events) %>% 
      group_by(year, month, day) %>%
      summarize(daily_events=length(events), daily_ppt=length(events)*0.01)

sugar_daily$id <- "sugarloaf"
sugar_daily <- select(sugar_daily, id, year, month, day, daily_events, daily_ppt)
head(sugar_daily)

sugar_hourly <- sugar %>%
      select(date_time, year, month, day, hour, events) %>% 
      group_by(year, month, day, hour) %>%
      summarize(hourly_events=length(events), hourly_ppt=length(events)*0.01)
sugar_hourly$id <- "sugarloaf"
sugar_hourly <- select(sugar_hourly, id, year, month, day, hour, hourly_events, hourly_ppt)
head(sugar_hourly)


yahng <- fread("YAHNG_502848_2009_RG.txt")
head(yahng)
str(yahng)
yahng <- as.data.frame(select(yahng, date_time = 1, events = 2))
yahng$date_time2 <- strptime(yahng$date_time, format = "%m/%d/%y %H:%M")
yahng$year <- year(yahng$date_time2)
yahng$month <- month(yahng$date_time2)
yahng$day <- mday(yahng$date_time2)
yahng$hour <- hour(yahng$date_time2)

yahng_daily <- yahng %>% 
      select(date_time, year, month, day, hour, events) %>% 
      group_by(year, month, day) %>%
      summarize(daily_events=length(events), daily_ppt=length(events)*0.01)

yahng_daily$id <- "yahng"
yahng_daily <- select(yahng_daily, id, year, month, day, daily_events, daily_ppt)
head(yahng_daily)

yahng_hourly <- yahng %>%
      select(date_time, year, month, day, hour, events) %>% 
      group_by(year, month, day, hour) %>%
      summarize(hourly_events=length(events), hourly_ppt=length(events)*0.01)
yahng_hourly$id <- "yahng"
yahng_hourly <- select(yahng_hourly, id, year, month, day, hour, hourly_events, hourly_ppt)
head(yahng_hourly)



write.csv(badg_daily, "Rain_Gauge/2_RG_EXPORTS/special_cases/badger_day_2004.csv")
write.csv(badg_hourly, "Rain_Gauge/2_RG_EXPORTS/special_cases/badger_hr_2004.csv")
write.csv(sec_daily, "Rain_Gauge/2_RG_EXPORTS/special_cases/sec_day_2007.csv")
write.csv(sec_hourly, "Rain_Gauge/2_RG_EXPORTS/special_cases/sec_hr_2007.csv")
write.csv(sugar_daily, "Rain_Gauge/2_RG_EXPORTS/special_cases/sugar_day_2007_2009.csv")
write.csv(sugar_hourly, "Rain_Gauge/2_RG_EXPORTS/special_cases/sugar_hr_2007_2009.csv")
write.csv(yahng_daily, "Rain_Gauge/2_RG_EXPORTS/special_cases/yahng_day_2009.csv")
write.csv(yahng_hourly, "Rain_Gauge/2_RG_EXPORTS/special_cases/yahng_hr_2009.csv")


# library(zoo)
# library(chron)
# library(xts)
# badg_zoo <- zoo(badg$events, badg$date_time2)
# anyDuplicated(badg_zoo)
# badg_zoo <- badg_zoo[-1404,]
# 
# badg_hourly <- to.hourly(badg_zoo)
# 
# str(badg_hourly)
# plot(badg_hourly)


#### Make database by compiling all the files together ####
setwd("~/wwdillon/soco_ppt")
files <- list.files("Rain_Gauge/2_RG_EXPORTS", pattern="*.csv", full.names=TRUE)
# fnames <- sub("^([^.]*).*", "\\1", basename(files))
# gauge_names <- sub("^([^_.]*).*", "\\1", basename(files))
# gname <- sub("^([^_.]*).*", "\\1", basename(files))


y_hr09 <- fread("Rain_Gauge/2_RG_EXPORTS/special_cases/yahng_hr_2009.csv")
y_dy09 <- fread("Rain_Gauge/2_RG_EXPORTS/special_cases/yahng_day_2009.csv")
s_hr07 <- fread("Rain_Gauge/2_RG_EXPORTS/special_cases/sugar_hr_2007_2009.csv")
s_dy07 <- fread("Rain_Gauge/2_RG_EXPORTS/special_cases/sugar_day_2007_2009.csv")
sec_hr07 <- fread("Rain_Gauge/2_RG_EXPORTS/special_cases/sec_hr_2007.csv")
sec_dy07 <- fread("Rain_Gauge/2_RG_EXPORTS/special_cases/sec_day_2007.csv")
ba_hr04 <- fread("Rain_Gauge/2_RG_EXPORTS/special_cases/badger_hr_2004.csv")
ba_dy04 <- fread("Rain_Gauge/2_RG_EXPORTS/special_cases/badger_day_2004.csv")



rg_data <- ldply(files, function(i){fread(i)})

# rg_data <- ldply(files, function(i){
#       read.csv(i, skip=2, stringsAsFactors=FALSE, col.names = c("date", "time","events","daily_events","hourly_events"))
#       # fnames <- sub("^([^.]*).*", "\\1", basename(i))
#       gauge_name <- sub("^([^_.]*).*", "\\1", basename(i))
#       i$id <- gauge_name
# })
head(rg_data)

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

rg_data$date2 <- strptime(rg_data$date, format="%m/%d/%Y", tz="America/Los_Angeles")

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



