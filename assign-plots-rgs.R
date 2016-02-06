#' Assign Rain Gauges to Plots
#' 
#+ load data ####
library(rgdal); library(plyr); library(dplyr)
soco_plots <- readOGR("shapefiles", "soco_plots_metric", verbose = F)
summary(soco_plots)
soco_plots@data <- soco_plots@data %>% 
      select(PLOT_ID, X, Y) %>% 
      rename(plotid = PLOT_ID, lon_utm = X, lat_utm = Y)
soco_plots@data$plotid <- as.factor(tolower(soco_plots@data$plotid))


rgpoly04 <- readOGR("shapefiles", "rg04_vpolys", verbose = F)
rgpoly05 <- readOGR("shapefiles", "rg05_vpolys", verbose = F)
rgpoly06 <- readOGR("shapefiles", "rg06_vpolys", verbose = F)
rgpoly07 <- readOGR("shapefiles", "rg07_vpolys", verbose = F)
rgpoly08 <- readOGR("shapefiles", "rg08_vpolys", verbose = F)
rgpoly09 <- readOGR("shapefiles", "rg09_vpolys", verbose = F)
rgpoly10 <- readOGR("shapefiles", "rg10_vpolys", verbose = F)
rgpoly11 <- readOGR("shapefiles", "rg11_vpolys", verbose = F)
rgpoly12 <- readOGR("shapefiles", "rg12_vpolys", verbose = F)
rgpoly14 <- readOGR("shapefiles", "rg14_vpolys", verbose = F)

#+ assign station id to plots ####
library(raster); library(rgeos)
rgs_plots04 <- cbind(soco_plots@data, extract(rgpoly04, soco_plots))
# summary(rgs_plots04)
rgs_plots05 <- cbind(soco_plots@data, extract(rgpoly05, soco_plots))
# summary(rgs_plots05)
rgs_plots06 <- cbind(soco_plots@data, extract(rgpoly06, soco_plots))
# summary(rgs_plots06)
rgs_plots07 <- cbind(soco_plots@data, extract(rgpoly07, soco_plots))
# summary(rgs_plots07)
rgs_plots08 <- cbind(soco_plots@data, extract(rgpoly08, soco_plots))
# summary(rgs_plots08)
rgs_plots09 <- cbind(soco_plots@data, extract(rgpoly09, soco_plots))
# summary(rgs_plots09)
rgs_plots10 <- cbind(soco_plots@data, extract(rgpoly10, soco_plots))
# summary(rgs_plots10)
rgs_plots11 <- cbind(soco_plots@data, extract(rgpoly11, soco_plots))
# summary(rgs_plots11)
rgs_plots12 <- cbind(soco_plots@data, extract(rgpoly12, soco_plots))
# summary(rgs_plots12)
rgs_plots14 <- cbind(soco_plots@data, extract(rgpoly14, soco_plots))
# summary(rgs_plots14)
detach("package:raster", unload = T)

rgs_plots04 <- select(rgs_plots04, plotid:stationid) %>% 
      mutate(year = 2004)
rgs_plots05 <- select(rgs_plots05, plotid:stationid) %>% 
      mutate(year = 2005)
rgs_plots06 <- select(rgs_plots06, plotid:stationid) %>% 
      mutate(year = 2006)
rgs_plots07 <- select(rgs_plots07, plotid:stationid) %>% 
      mutate(year = 2007)
rgs_plots08 <- select(rgs_plots08, plotid:stationid) %>% 
      mutate(year = 2008)
rgs_plots09 <- select(rgs_plots09, plotid:stationid) %>% 
      mutate(year = 2009)
rgs_plots10 <- select(rgs_plots10, plotid:stationid) %>% 
      mutate(year = 2010)
rgs_plots11 <- select(rgs_plots11, plotid:stationid) %>% 
      mutate(year = 2011)
rgs_plots12 <- select(rgs_plots12, plotid:stationid) %>% 
      mutate(year = 2012)
rgs_plots14 <- select(rgs_plots14, plotid:stationid) %>% 
      mutate(year = 2014)

rgs_plots <- rbind(rgs_plots04,rgs_plots05,rgs_plots06,rgs_plots07,rgs_plots08,
                   rgs_plots09,rgs_plots10,rgs_plots11,rgs_plots12,rgs_plots14)
head(rgs_plots)

#+ load temperature data
long_temp <- readRDS("~/Documents/microclimate_tonini/Temperature/eof_pred_long.rds")
head(long_temp)
long_temp <- select(long_temp, -posix_time)
long_temp$date <- as.Date(paste(
      long_temp$year, long_temp$month, long_temp$day, sep = "/"))

long_temp$plotid <- tolower(long_temp$plotid)
long_temp <- filter(long_temp, date >= "2003-11-01")
long_temp
# summary(long_temp)

long_temp <- long_temp %>% mutate(sample_year = ifelse(
      date >= "2003-11-01" & date <= "2004-05-31", 2004, 
      ifelse(date >= "2004-11-01" & date <= "2005-05-31", 2005,
             ifelse(date >= "2005-11-01" & date <= "2006-05-31", 2006,
                    ifelse(date >= "2006-11-01" & date <= "2007-05-31", 2007,
                           ifelse(date >= "2007-11-01" & date <= "2008-05-31", 2008,
                                  ifelse(date >= "2008-11-01" & date <= "2009-05-31", 2009,
                                         ifelse(date >= "2009-11-01" & date <= "2010-05-31", 2010,
                                                ifelse(date >= "2010-11-01" & date <= "2011-05-31", 2011, ifelse(date >= "2011-11-01" & date <= "2012-05-31", 2012,
                                                                                                                 ifelse(date >= "2013-11-01" & date <= "2014-05-31", 2014, NA)))))))))))

rgs_plots <- left_join(
      select(long_temp, date, hour, plotid, temp, sample_year),
      select(rgs_plots, plotid, stationid, year),
      by = c("plotid", "sample_year"="year")
)
# long_temp$plotid <- as.factor(long_temp$plotid)
# long_temp$sample_year <- as.factor(long_temp$sample_year)
# rgs_plots$year <- as.factor(rgs_plots$year)
head(rgs_plots)
rm(long_temp)

#' Filter to Rainy Days
#' 
#+ load data ####
# library(plyr); library(dplyr)
## load daily rainfall data
daily_rg <- readRDS("dy_rg_data_corrected.rds")
head(daily_rg)
summary(daily_rg)
daily_rg$stationid <- as.factor(daily_rg$stationid)

#' Filter daily rainfall data to days with measurable precipitation
#+ filter daily rain data ####
daily_rg <- daily_rg %>% filter(daily_ppt > 0.01)
summary(daily_rg)

#' Join dates with rainfall amounts to plot hourly temperature data
#+ join rainfall temperature ####
rgs_plots <- left_join(rgs_plots,
                       select(daily_rg, stationid, daily_ppt, date),
                       by = c("stationid","date"))
summary(rgs_plots)

# drop rows with NAs
rgs_plots <- na.omit(rgs_plots)

write.csv(rgs_plots, "wet-days-temps.csv")



      