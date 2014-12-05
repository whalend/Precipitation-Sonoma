## Precipitation Interpolation for Sonoma County

Project location: `P:\geospatial\Research\rkmeente\Workspaces\wwdillon\soco_ppt`

#### Goal: summarize the precipitation events into hourly and daily values
`Conversion factor: 1 event = 0.01 inches`

These data (likely in combination with other available external data) are primarily intended for calculating surfaces of precipitation variables that are of interest for modeling *P. ramorum* and SOD in the Sonoma County study system. Other uses may include use for examining various methodological applications related to modeling precipitation at relatively fine spatial scales.

10/8/2014 -  The files in the *all_years_raw_exports* folder have been revised to include and `id` column with the location (landowner) name. These now all share the same column names and what I hope is the same format of the data in each column.

I have been backing up a copy of the *soco_ppt* folder onto my flash drive.

10/31/2014 - I now have 112 `.csv` files in the `2_RG_EXPORTS` folder that represent the available data from each rain gauge. These are all backed up on my flash drive. Each file is a summary of the daily and hourly events summarized and exported using the HoboWare software.

11/10/2014 - There are four year-location combinations that were not in the Onset proprietary format. I manipulated these in `R` to create an hourly events summary file and a daily events summary file.

My next step is to create an hourly database and a daily database that each incorporate all of the files. I am working on this in the `explore_report.Rmd` document.