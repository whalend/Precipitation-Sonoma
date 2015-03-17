#### Closer look at MITSUI precip data for Jeff Wilcox (manager)
#### 2015-03-12


# Started by loading the .RData file associated with the project directory
# These data 
load("~/Documents/soco_ppt/.RData")
ls()
# [1] "daily_special"  "dy_rg_data"     "hourly_special" "hr_rg_data"    
# [5] "rg_data"        "rg_data1" 
summary(rg_data)
summary(rg_data1)
## These two data frames are close to equivalent. `rg_data1` has the `NA`s replaced with zeroes. The summary values remain the same.

library(dplyr)
library(ggplot2)

mitsu_ppt <- filter(dy_rg_data, id == "mitsui")
summary(mitsu_ppt)
qplot(date, daily_ppt, data = mitsu_ppt, ylab = "Rainfall (inches)",
      main = "Daily Rainfall 11/1/2003 - 4/30/2014 (Mitsui)", color = 2, 
      geom = c("point", "line")) +
      theme_bw() + theme(legend.position = "none")
ggsave("deliverables/mitsu_daily.png", width = 11, height = 7, dpi = 300)
write.csv(mitsu_ppt, "deliverables/mitsu_daily.csv")


# Monthly precipitation (ppt) by year, month, and gauge id
monthly_ppt_id <- dy_rg_data %>%
      group_by(year, month, id) %>%# This grouping order causes reordering by year, month, then id
      summarise(monthly_ppt = sum(daily_ppt))# Create total monthly precip
monthly_ppt_id
# Add date factor variable
monthly_ppt_id <- mutate(monthly_ppt_id, date = paste(year,"-",month, sep = ""))
# Convert date factor to `date` format for plotting
monthly_ppt_id$date <- as.Date(paste(monthly_ppt_id$date, "-01", sep=""))

mitsu_month <- filter(monthly_ppt_id, id == "mitsui")
mitsu_month
qplot(date, monthly_ppt, data = mitsu_month, ylab = "Rainfall (inches)",
      main = "Monthly rainfall 11/2003-4/2004 (Mitsui)", color = 2, 
      geom = c("point", "line")) +
      theme_bw() + theme(legend.position = "none") +
      scale_x_date(breaks = date_breaks("6 months"), 
                   labels = date_format("%m/%y"),
                   minor_breaks = "1 month") +
      xlab("date (month/year)") 
ggsave("deliverables/mitsu_monthly.png", width = 11, height = 7, dpi = 300)
qplot(date, monthly_ppt, data = mitsu_month %>% filter(year == 2014))
qplot(month, monthly_ppt, data = mitsu_month, facets = year ~ .)


qplot(date, daily_ppt, 
      data = dy_rg_data,
      geom = c("point","line"), ylab = "Daily rainfall (inches)", 
      facets = id ~ ., color = id) + 
      theme_bw()

qplot(date, daily_ppt, 
      data = dy_rg_data %>% filter(id == "mitsui"),
      geom = c("point","line"), ylab = "Daily rainfall (inches)", color = month) + 
      theme_bw()


dy_plot <- ggplot(data = dy_rg_data %>%
                        filter(id == "yahng" | id == "mitsui" | id == "backman"),
                  aes(x = date, y = daily_ppt, color = id)) + 
      geom_point(size=2) +
      ylab("Daily rainfall (inches)") 

library(scales)
dy_plot + geom_line() + facet_grid(id ~ ., scales = "fixed") +
      theme_bw() + theme(legend.position = "none") +
      scale_x_date(breaks = date_breaks("6 months"), 
                   labels = date_format("%m/%y"),
                   minor_breaks = "1 month") +
      xlab("date (month/year)") + ggtitle("Daily Rainfall 2004-2013")
ggsave("deliverables/compare_mitsu_daily.png", width = 11, height = 7, dpi = 300)

mo_plot <- ggplot(data = monthly_ppt_id %>% filter(id == "yahng" | id == "mitsui" | id == "backman"),
                  aes(x = date, y = monthly_ppt, color = id)) + 
      geom_point(size=2) +
      ylab("Monthly rainfall (inches)")
mo_plot + geom_line() + facet_grid(id ~ ., scales = "fixed") +
      theme_bw() + theme(legend.position = "none") +
      scale_x_date(breaks = date_breaks("6 months"), 
                   labels = date_format("%m/%y"),
                   minor_breaks = "1 month") +
      xlab("date (month/year)") + ggtitle("Monthly Rainfall 2004-2013")
ggsave("deliverables/compare_mitsu_monthly.png", width = 11, height = 7, dpi = 300)




# Aggregate to mean monthly precip across all gauges, so exclude id from the data frame `monthly_ppt_id`
monthly_ppt <- monthly_ppt_id %>%
      group_by(year, month, date) %>%
      summarise(avg_monthly_ppt = mean(monthly_ppt, na.rm=TRUE))
summary(monthly_ppt)