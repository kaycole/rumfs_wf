#----------------------# 
# nj dep wf data
#----------------------# 

#----------------------# 
# load packages
#----------------------#
library(readxl)
require(dplyr)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
require(rgdal)
require(sp)
#----------------------#

#----------------------# 
# load data
#----------------------# 
njdep.catch <- read_excel("T:/Personal Folders/! FORMER RUMFS EMPLOYEES !/Coleman/wf_new/NJOTWinterFlounderCatch.xlsx")
njdep.lengths <- read_excel("T:/Personal Folders/! FORMER RUMFS EMPLOYEES !/Coleman/wf_new/NJOTWinterFlounderLengths.xlsx")
usa <- map_data("usa")
#----------------------# 

#----------------------# 
# transform data
#----------------------# 
names(njdep.lengths) = tolower(names(njdep.lengths)) # no spatial info
names(njdep.catch) = tolower(names(njdep.catch)) 

njdep.catch = njdep.catch %>% 
  mutate(slat = as.numeric(slat),
         slong = as.numeric(slong),
         elat = as.numeric(elat),
         elong = as.numeric(elong),
         slat = ((((slat/100)-(slat %/% 100)) / 60)*100) + (slat %/% 100), #change dec.min to dec.deg
         slong = (((((slong/100)-(slong %/% 100)) / 60)*100) + (slong %/% 100))*-1, #change dec.min to dec.deg
         elat = ((((elat/100)-(elat %/% 100)) / 60)*100) + (elat %/% 100), #change dec.min to dec.deg
         elong = (((((elong/100)-(elong %/% 100)) / 60)*100) + (elong %/% 100))*-1) %>%  #change dec.min to dec.deg
  rowwise %>% 
  mutate(depth = mean(c(mindepth, maxdepth), na.rm=T),
         lat = mean(c(slat, elat), na.rm=T),
         lon = mean(c(slong, elong), na.rm=T)) %>% 
  as.data.frame()

# ggplot(njdep.catch,aes(lon,lat))+geom_point()+theme_bw()

#flag bad data for removal
njdep.catch = njdep.catch %>% mutate(flag = 0,
                                     flag = ifelse(lat>39.6 & lon<c(-74.25),1,flag),
                                     flag = ifelse(lat<39.5 & lon>c(-73.75),1,flag)) %>%
  filter(flag %in% 0) %>% dplyr::select(-flag)
#----------------------# 


