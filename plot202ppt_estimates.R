#' # Compare Precipitation Estimates at Plot Locations
#' 
#' I want to compare the rainfall/rainy days estimates for each season produced using the different methods.
#' 
#'  1. 2D interpolation (rainfall ~~& rainy days~~)
#'  2. ~~3D interpolation (rainfall & rainy days)~~
#'  3. Voronoi polygons (rainfall & rainy days)
#'  4. ~~Regression model (rainfall & rainy days)~~
#'  5. Downscaled PRISM (rainfall only)
#'  
#+ Load data from shapefiles ####
library(sp); library(rgdal); library(dplyr)
ppt_reg <- readOGR("shapefiles/", "plot202ppt_regression")# regression estimates
ppt_int <- readOGR("shapefiles/", "interpolated_ppt")# interpolation estimates
ppt_vor <- readOGR("shapefiles/", "plot202ppt_voronoi")# Voronoi estimates
ppt_psm <- readOGR("shapefiles/", "plot202ppt_PRISM")# PRISM estimates

summary(ppt_reg)

# make a dataset of the number of rainy days estimates
ppt_days <- ppt_reg
ppt_days@data <- select(ppt_days@data, PLOT_ID, X, Y, contains('dys'))
summary(ppt_int)
ppt_days@data <- left_join(ppt_days@data, 
                           select(ppt_int@data, PLOT_ID, contains('dys')), 
                           by = "PLOT_ID")
summary(ppt_vor)
ppt_days@data <- left_join(ppt_days@data,
                           select(ppt_vor@data, PLOT_ID, contains('dys')),
                           by = "PLOT_ID")
summary(ppt_days)

# make a dataset of the total rainfall estimates
ppt_total <- ppt_reg
ppt_total@data <- select(ppt_total@data, PLOT_ID, X, Y, contains('tot'))
summary(ppt_int)
ppt_total@data <- left_join(ppt_total@data,
                            select(ppt_int@data, PLOT_ID, contains('ppt')),
                            by = "PLOT_ID")
summary(ppt_vor)
ppt_total@data <- left_join(ppt_total@data,
                            select(ppt_vor@data, PLOT_ID, contains('tot')),
                            by = "PLOT_ID")
summary(ppt_psm)
ppt_total@data <- left_join(ppt_total@data,
                            select(ppt_psm@data, PLOT_ID, contains('sum')),
                            by = "PLOT_ID")
summary(ppt_total)

#' Now there are two datasets, one for number of rainy days and one for total rainfall, each containing estimates from the different methodologies.

#' ## Pairs Plots
#' 
#+ load pairs panel functions ####
source("~/Documents/Rscratch/panel_cor.R")# source panel functions; path specific to machine and file name

#' ### Rainy Days
#' I'm making a pairs plot for each season of the number of rainy days estimates from the different methods to see how they compare/correlate.
#' 
#+ pairs plots of rainy days estimates ####
summary(ppt_days)
pairs(select(ppt_days@data, contains('04'), -PLOT_ID, -X, -Y, -contains('_r')),
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2004 Rainy Days Estimates")
#' The correlation between the 2D/3D interpolated estimates is strong (>0.90), with the relationship between the 2D/3D and Voronoi estimates ranging from 0.63 (3D ~ Voronoi) to 0.84 (2D ~ Voronoi). All correlations are positive.
#' ***
pairs(select(ppt_days@data, contains('05'), -PLOT_ID, -X, -Y, -contains('_r')),
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2005 Rainy Days Estimates")
#' Strong correlations between 2D/3D/Voronoi estimates (>0.90), so the patterns at least match up, meaning that the inference from models using any of these should be similar.
#' ***
pairs(select(ppt_days@data, contains('06'), -PLOT_ID, -X, -Y, -contains('_r')),
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2006 Rainy Days Estimates")
#' There's more clustering of these point estimates, weaker correlation or 2D/3D with the Voronoi estimates (0.27 - 0.45), but all positive relationships.
#' ***
pairs(select(ppt_days@data, contains('07'), -PLOT_ID, -X, -Y, -contains('_r')),
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2007 Rainy Days Estimates")
#' Pretty strong correlation between the estimates from all three of these methods (0.81 - 0.95). 
#' ***
pairs(select(ppt_days@data, contains('08'), -PLOT_ID, -X, -Y, -contains('_r')),
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2008 Rainy Days Estimates")
#' All positive correlations ranging from 0.71 to 0.89, with the weakest being with the Voronoi polygon estimates.
#' ***
pairs(select(ppt_days@data, contains('09'), -PLOT_ID, -X, -Y, -contains('_r')),
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2009 Rainy Days Estimates")
#' All positive correlations, 0.72-0.96, again with the weakest being between the 2D/3D and Voronoi estimates. 
#' ***
pairs(select(ppt_days@data, contains('10'), -PLOT_ID, -X, -Y, -contains('_r')),
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2010 Rainy Days Estimates")
#' Positive correlations, 0.73 - 0.94, weakest between Voronoi and 2D/3D estimates.
#' ***
pairs(select(ppt_days@data, contains('11'), -PLOT_ID, -X, -Y, -contains('_r')),
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2011 Rainy Days Estimates")
#' Positive correlations, but overall weaker (0.40 - 0.74), strongest between 2D/3D and weakest between 3D and Voronoi. 
#' ***
pairs(select(ppt_days@data, contains('12'), -PLOT_ID, -X, -Y, -contains('_r')),
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2012 Rainy Days Estimates")
#' Strong correlation overall, 0.86 - 0.98, weakest between 3D and Voronoi estimates, strongest between 2D/3D.
#' ***
pairs(select(ppt_days@data, contains('14'), -PLOT_ID, -X, -Y, -contains('_r')),
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2014 Rainy Days Estimates")
#' Correlation 0.70 - 0.85, strongest between 3D and Voronoi, weakest between 2D and Voronoi. 
#' ***

#' ### Total Rainfall
#' As for the number of rainy days, I'm making pairs plots for each season of the total rainfall estimates from the different methodologies to compare correlations.
#' 
#+ pairs plots of total rainfall estimates ####
summary(ppt_total)
pairs(select(ppt_total@data, contains('04'), -PLOT_ID, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2004 Rainfall Estimates")
#' The regression estimates for 2004 are very weakly correlated with estimates from the other methods. The correlation between Voronoi polygons and the 2D/3D interpolations, as well as between the 2D/3D estimates, is pretty strong (>0.83). The PRISM data is more weakly correlated with the 2D/3D/Vornoi estimates, but all negative relationships (-0.36 - -0.44), so higher values from PRISM correlate with generally lower values at the same locations from the other methods.
#' ***
#+
pairs(select(ppt_total@data, contains('05'), -PLOT_ID, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2005 Rainfall Estimates")
#' Regression estimates are overall weakly correlated with estimates from the other methodologies, though strongest with PRISM (0.46). PRISM estimates are very weakly correlated with the 2D/3D/Voronoi estimates, all <0.07. Strong correlation between 2D/3D/Voronoi, 0.89 - 0.99. So, I might expect inferences from models using regression or PRISM estimates compared to the 2D/3D/Voronoi estimates.
#' ***
#+
pairs(select(ppt_total@data, contains('06'), -PLOT_ID, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2006 Rainfall Estimates")
#' Regression correlations with the other estimation methodologies are all >0.60, but the correlation with PRISM estimates is negative (-0.65). The correlations between PRISM and the other methods are all weak and negative as well. Tighter correlations between 2D/3D/Voronoi estimates, 0.81 - 0.88.
#' ***
#+
pairs(select(ppt_total@data, contains('07'), -PLOT_ID, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2007 Rainfall Estimates")
#' Non-linear relationship between regression and 2D estimates, but also the strongest correlation between regression and the other methods (-0.33). Correlations of any strength with PRISM are all negative. The strongest overall correlation is between 2D and Vornoi methods at 0.75. So, there might be some variability in the inference from models using estimates from the different methods.
#' ***
#+
pairs(select(ppt_total@data, contains('08'), -PLOT_ID, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2008 Rainfall Estimates")
#' All of the correlations between the estimates from the different methods are positive, the weakest (0.23) being between 2D and PRISM, the strongest (0.89) between 2D and Voronoi. So, the inference from models using estimates from the different methods are likely to be similar.
#' ***
#+
pairs(select(ppt_total@data, contains('09'), -PLOT_ID, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2009 Rainfall Estimates")
#' All of these correlations are positive, the weakest between PRISM and Voronoi (0.08) and the strongest between PRISM and regression (0.81). So, probably similar inference from models using estimates from the different methods.
#' ***
#+
pairs(select(ppt_total@data, contains('10'), -PLOT_ID, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2010 Rainfall Estimates")
#' Correlation between regression and PRISM estimates is negative. Overall, correlations between PRISM and the other estimates are all pretty weak (max = -0.21). The 2D/3D/Voronoi estimates have the strongest correlations (0.83 - 0.97). Inference from models using the PRISM estimates are likely to be different from models using estimates from the other methods. This is the last season for which I have PRISM data.
#' ***
#+
pairs(select(ppt_total@data, contains('11'), -PLOT_ID, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2011 Rainfall Estimates")
#' Correlation with regression estimates are very weak, all < 0.082. The correlations between 2D/3D/Voronoi estimates are fairly strong (0.83 - 0.98).
#' ***
#+
pairs(select(ppt_total@data, contains('12'), -PLOT_ID, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2012 Rainfall Estimates")
#' Correlation of these estimates are all reasonably strong (0.47 - 0.93), strongest between 2D/3D and weakest between regression and Voronoi. So, model inference from these estimates are likely to be similar.
#' ***
#+
pairs(select(ppt_total@data, contains('14'), -PLOT_ID, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2014 Rainfall Estimates")
#' Correlation of these estimates are all reasonably strong as well (0.49 - 0.86), strongest between 2D and Voronoi, weakest between regression and Voronoi. Model inference from these estimates are likely to all be similar.
#' ***
#' 
#' # UPDATE
#' I recalculated continuous rainfall surfaces using only 2D spline interpolation, and updated the Voronoi polygon files. During discussion of my initial efforts with Ryan, he recommended using settings that captured the major trend while not trying to assume too much of the data. This lead me to avoiding the strong bulls-eye patterning, and generally lower values for the tension parameter. I also added an estimation for the 'sampling season', defined as November 1 - April 30, based on recent discussion with Sarah about the variables she used in her survival analysis model.
#' 
#+ load new dataset ####
library(sp); library(rgdal); library(dplyr)
rainfall <- readOGR("shapefiles/", "plot202ppt")
summary(rainfall)
rainfall@data <- select(rainfall@data, plotid, elev_m, everything(), -cat)
names(rainfall@data)
#'
#' The variables that have 'rs' are for the rainy season (Nov-May), and the variables that have 'ss' are for the sampling season (Nov-Apr). A 'v' indicates the values are from the Voronoi defined polygons, while the other values are from 2D spline interpolations in GRASS GIS.
#' 
#+ new dataset pairs plots ####
pairs(select(rainfall@data, contains('04'), -plotid, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2004 Rainfall Estimates")
pairs(select(rainfall@data, contains('05'), -plotid, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2005 Rainfall Estimates")
pairs(select(rainfall@data, contains('06'), -plotid, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2006 Rainfall Estimates")
pairs(select(rainfall@data, contains('07'), -plotid, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2007 Rainfall Estimates")
pairs(select(rainfall@data, contains('08'), -plotid, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2008 Rainfall Estimates")
pairs(select(rainfall@data, contains('09'), -plotid, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2009 Rainfall Estimates")
pairs(select(rainfall@data, contains('10'), -plotid, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2010 Rainfall Estimates")
pairs(select(rainfall@data, contains('11'), -plotid, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2011 Rainfall Estimates")
pairs(select(rainfall@data, contains('12'), -plotid, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2012 Rainfall Estimates")
pairs(select(rainfall@data, contains('13'), -plotid, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2013 Rainfall Estimates")
pairs(select(rainfall@data, contains('14'), -plotid, -X, -Y), 
      upper.panel = panel.cor, diag.panel = panel.hist,
      main = "2014 Rainfall Estimates")

#+ Save RData with ppt_days and ppt_total ####
rm(ppt_psm); rm(ppt_reg); rm(ppt_int); rm(ppt_vor)
save.image("~/Documents/soco_ppt/plot_ppt_estimates.RData")



