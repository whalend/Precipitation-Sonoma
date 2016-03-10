#' # Wet Days Temperature Variables
#' 
#' Calculate the number of hours within selected temperature ranges during days that had measurable rainfall for each season.
#' 
#+ load data ####
library(plyr); library(dplyr)
## data developed in 'assign-plots-rgs.R' script
wet_days <- read.csv("wet-days-temps.csv")
head(wet_days); #wet_days <- wet_days[,-1]# remove 'X' row name column
str(wet_days)
wet_days$date <- as.Date(wet_days$date)# convert from 'factor' to 'Date'
summary(wet_days)

#' This has 2.775 million observations of hourly recorded temperature during "wet days," which were classified as having > 0.01 inches (0.254 mm) of precipitation. These values are the equivalent of one tip of the rain bucket equipment. We identified three initial temperature thresholds to examine for the wet days of each season:
#'  
#'  1. < 14 C, cool, but growing/sporulating based on field and lab studies
#'  2. 14 C - 22 C "optimal" according to experimental lab studies
#'  3. > 22 C, hot, with growth/sporulation declining
#'  
#' These thresholds will provide coverage of the entire range of possible temperatures, so adding up the number of hours from each of the subsets should equal 2,775,000. I expect that during wet days there will be many more hours at the cool temperature than either the optimal or hot ranges across all seasons.
#' 
#' The summary statistics of the temperature variable ('temp') indicates some hefty outliers, particularly on the high side, compared to the mean, median, and interquartile range. It's possible that these should be excluded from the data, so I'm going to investigate these outlying values. It's also possible that they are legitimate or that I won't be able to really make a clear distinction. 
#' 
#+ investigate outlier temperatures ####
library(ggplot2)
# plot(temp ~ date, data = filter(wet_days, sample_year == 2004),
#      xlab = "Date", ylab = "Temperature",
#      main = "2004 Rainy Season Wet Days Temperatures")

#+ 2004 season -------------------------------------------------------------
ggplot(filter(wet_days, sample_year == 2004), aes(date, temp)) +
      geom_point() +
      labs(title = "2004 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")
filter(wet_days, sample_year == 2004, temp > 27)
      
ggplot(filter(wet_days, date > "2004-01-01", date < "2004-02-28"), 
       aes(date, temp)) +
      geom_point() +
      labs(title = "2004 Rainy Season Wet Days Temperatures - Subset",
           x = "Date", y = "Temperature")

filter(wet_days, date > "2004-01-01", date < "2004-02-28", temp > 18)
ggplot(filter(wet_days, plotid == "lars01", sample_year == 2004), 
       aes(date, temp)) +
      geom_point() +
      labs(title = "2004 Rainy Season Wet Days Temperatures - Plot LARS01",
           x = "Date", y = "Temperature")

#' This set of values in 2004 appear well outside of what the rest of the temperatures were during this particular time period. It looks like the logger may have been brought back to the lab and continued to record for about a month. This may have implications back to filling in the missing temperature data - were these values part of the data used to fill in the missing values or were they missing values that we filled in?
#+
outliers <- filter(wet_days, date > "2004-01-01", date < "2004-02-28", temp > 18)
wet_days <- anti_join(wet_days, outliers)

ggplot(filter(wet_days, sample_year == 2004), aes(date, temp)) +
      geom_point() +
      labs(title = "2004 Rainy Season Wet Days Temperatures, Outliers Removed",
           x = "Date", y = "Temperature")

#+ 2005 season -------------------------------------------------------------
ggplot(filter(wet_days, sample_year == 2005), aes(date, temp)) +
      geom_point() +
      labs(title = "2005 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")

#' No temperature values stand out as outliers on wet days during the 2005 rainy season.

#+ 2006 season -------------------------------------------------------------
ggplot(filter(wet_days, sample_year == 2006), aes(date, temp)) +
      geom_point() +
      labs(title = "2006 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")

#' No temperature values standing out for wet days during 2006 rainy season

#+ 2007 season -------------------------------------------------------------
ggplot(filter(wet_days, sample_year == 2007), aes(date, temp)) +
      geom_point() +
      labs(title = "2007 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")
#' No temperature values standing out for wet days during 2006 rainy season

#+ 2008 season -------------------------------------------------------------
ggplot(filter(wet_days, sample_year == 2008), aes(date, temp)) +
      geom_point() +
      labs(title = "2008 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")
unique(filter(wet_days, sample_year == 2008, date > "2008-05-15")$plotid)

#' 89 of the plots had wet days on May 24th and/or May 25th, though it appears that the plots were all either assigned or oddly recorded the same temperature value for these dates. A summary of the filtered data gives shows that all the temperature values were 13.51, which doesn't make sense over multiple hours for multiple days. Since I'm trying to make a combinatorial variable of temperature on wet days I think this could have a strong skewing effect on the data because it would add 2856 hours to the <14 C threshold. 
#+
outliers <- filter(wet_days, sample_year == 2008, date > "2008-05-15")
wet_days <- anti_join(wet_days, outliers)

#+ 2009 season -------------------------------------------------------------
ggplot(filter(wet_days, sample_year == 2009), aes(date, temp)) +
      geom_point() +
      labs(title = "2009 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")
summary(filter(wet_days, sample_year == 2009, temp > 30))

#' It is a little suspicious to me that only two plots recorded temperatures above 30, and the majority are at KUNDE01, which is fairly nearby other plots.
#+
ggplot(filter(wet_days, sample_year == 2009, date > "2009-04-20", date < "2009-05-15"), aes(date, temp)) +
      geom_point() +
      labs(title = "2009 Rainy Season Wet Days Temperatures - Subset",
           x = "Date", y = "Temperature")
filter(wet_days, sample_year == 2009, date > "2009-04-20", date < "2009-05-15", temp > 23)

ggplot(filter(wet_days, sample_year == 2009, plotid == "kunde01" | plotid == "kunde02"), aes(date, temp)) +
      geom_point(aes(color = plotid)) +
      labs(title = "2009 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")
qplot(plotid, temp, data = filter(wet_days, sample_year == 2009, plotid == "kunde01" | plotid == "kunde02"), geom = "boxplot")

#' The one really different period during the end of April through the first week of May, but otherwise the temperatures at these locations seem to track pretty closely.


#+ 2010 season -------------------------------------------------------------
ggplot(filter(wet_days, sample_year == 2010), aes(date, temp)) +
      geom_point() +
      labs(title = "2010 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")
summary(filter(wet_days, sample_year == 2010, temp > 25))

#' I'm in a bit of disbelief about these 25+ C (77 F) temperatures during the rainy season months, especially when they aren't at least in April or May. Some of these temperatures seem way up there (30+ C).

#+ this removes the ones that I'm especially skeptical about
outliers <- filter(wet_days, date > "2009-12-01", date < "2010-03-15", temp > 24)
wet_days <- anti_join(wet_days, outliers)

#+ 2011 season -------------------------------------------------------------
ggplot(filter(wet_days, sample_year == 2011), aes(date, temp)) +
      geom_point() +
      labs(title = "2011 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")
filter(wet_days, sample_year == 2011, temp > 25)# 209 observations
filter(wet_days, sample_year == 2011, temp > 22)# 404 observations

#' Again, I'm in disbelief of these temperatures that are well above 25 C. The majority of these are from three plots during November or December (FOP333, FOP340, JROTH05) and account for over half the observations >22 C.
#+
outliers <- filter(wet_days, date > "2010-11-01", date < "2011-01-01" , temp > 25)
wet_days <- anti_join(wet_days, outliers)

#+ 2012 season -------------------------------------------------------------
ggplot(filter(wet_days, sample_year == 2012), aes(date, temp)) +
      geom_point() +
      labs(title = "2012 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")
filter(wet_days, sample_year == 2012, temp > 35)
# filter(wet_days, sample_year == 2012, temp > 20, date > "2012-03-15", date < "2012-03-30")

#' One outlier that is a single observation (>35 C) should definitely be removed. It looks like there may have a warm spell for a few days during the last half of April.
#+
wet_days <- filter(wet_days, date != "2012-03-15" | hour != 5 | plotid != "gard01")

# 2013 season -------------------------------------------------------------
ggplot(filter(wet_days, sample_year == 2013), aes(date, temp)) +
      geom_point() +
      labs(title = "2012 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")
filter(wet_days, sample_year == 2013, date > "2013-03-01", date < "2013-03-10", temp > 22)

wet_days <- filter(wet_days, date != "2013-03-05" | hour != 10 | plotid != "sdc03")

#+ 2014 season -------------------------------------------------------------
ggplot(filter(wet_days, sample_year == 2014), aes(date, temp)) +
      geom_point() +
      labs(title = "2014 Rainy Season Wet Days Temperatures",
           x = "Date", y = "Temperature")
filter(wet_days, sample_year == 2014, temp > 25)

#' I don't see any notable outlying temperature values for this season, at least relatively speaking. There are still a number of observations that were >25 C.
#+
rm(outliers)


#+ outliers investigation summary ------------------------------------------
2775000 - 2771526# I removed 3474 observations (hours)
100*(3474/2775000)# This is about 1/10th of 1% of the observations


#+ summarize temperature thresholds ----------------------------------------
wet_days_hrs <- wet_days %>% 
      select(-stationid, -daily_ppt) %>% 
      group_by(plotid, sample_year) %>% 
      summarise(tothrs_wet = length(temp))

wet_days_hrs <- left_join(wet_days_hrs, wet_days %>% 
      select(-stationid, -daily_ppt) %>% 
      filter(temp <= 14) %>% 
      group_by(plotid, sample_year) %>% 
      summarise(hrsblw14_wet = length(temp)))

wet_days_hrs <- left_join(wet_days_hrs, wet_days %>% 
      select(-stationid, -daily_ppt) %>% 
      filter(temp > 14, temp <= 22) %>% 
      group_by(plotid, sample_year) %>% 
      summarise(hrs1422_wet = length(temp)))

wet_days_hrs <- left_join(wet_days_hrs, wet_days %>% 
      select(-stationid, -daily_ppt) %>% 
      filter(temp > 22) %>% 
      group_by(plotid, sample_year) %>% 
      summarise(hrsabv22_wet = length(temp)))

wet_days_hrs <- left_join(wet_days_hrs, wet_days %>% 
      select(-stationid, -daily_ppt) %>% 
      group_by(plotid, sample_year, date) %>% 
      summarise(daily_tmax = max(temp), daily_tmin = min(temp)) %>% 
      group_by(plotid, sample_year) %>% 
      summarise(avgtmax_wet = mean(daily_tmax), avgtmin_wet = mean(daily_tmin))
            )
wet_days_hrs <- left_join(wet_days_hrs, wet_days %>% 
      select(-stationid, -daily_ppt) %>% 
      group_by(plotid, sample_year) %>% 
      summarise(avgtemp_wet = mean(temp)))


wet_days_hrs <- left_join(wet_days_hrs, wet_days %>% 
                                select(-stationid, -daily_ppt) %>% 
                                filter(temp <= 10) %>% 
                                group_by(plotid, sample_year) %>% 
                                summarise(hrsblw10_wet = length(temp)))
wet_days_hrs <- left_join(wet_days_hrs, wet_days %>% 
                                select(-stationid, -daily_ppt) %>% 
                                filter(temp > 10, temp <= 20) %>% 
                                group_by(plotid, sample_year) %>% 
                                summarise(hrs1020_wet = length(temp)))
wet_days_hrs <- left_join(wet_days_hrs, wet_days %>% 
                                select(-stationid, -daily_ppt) %>% 
                                filter(temp > 20) %>% 
                                group_by(plotid, sample_year) %>% 
                                summarise(hrsabv20_wet = length(temp)))

wet_days_hrs
summary(wet_days_hrs)
# boxplot(hrsblw14_wet ~ sample_year, data = wet_days_hrs)
filter(wet_days_hrs, tothrs_wet < 300)
filter(wet_days_hrs, is.na(hrs1422_wet))
wet_days_hrs[is.na(wet_days_hrs)] <- 0
write.csv(wet_days_hrs, "wet-days-temperature-variables.csv")
write.csv(wet_days_hrs, "~/GitHub/superspreaders/analysis/data/wet-days-temperature-variables.csv")

#' It looks like nearly all of the temperatures recorded during wet days are below 14 C, so that doesn't address questions about different temperature thresholds. I can say something about the variability in the number of hours at or below 14 C in relation to other biological and physical plot characteristics. The 10 C threshold appears to provide a more equitable split between the lower temperature and 'optimal' between 10 C and 20 C grouping.

#+ panel plot ####
panel.hist <- function(x, ...){
      usr <- par("usr"); on.exit(par(usr))
      par(usr = c(usr[1:2], 0, 1.5) )
      h <- hist(x, plot = FALSE)
      breaks <- h$breaks; nB <- length(breaks)
      y <- h$counts; y <- y/max(y)
      rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
}
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...){
      usr <- par("usr"); on.exit(par(usr))
      par(usr = c(0, 1, 0, 1))
      r <- abs(cor(x, y))
      txt <- format(c(r, 0.123456789), digits = digits)[1]
      txt <- paste0(prefix, txt)
      if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
      text(0.5, 0.5, txt, cex = cex.cor * r)
}

pairs(select(wet_days_hrs, -plotid), diag.panel = panel.hist, lower.panel = panel.cor)

#' The vast majority of the temperatures when it's wet during the rainy season are at or below 14 C, and even at or below 10 C. This is shown by the strong positive correlation between the total number of hours recorded when it's wet and the subsetted number of hours for each of these thresholds.





