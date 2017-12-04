# -------------------- #
# data downloaded from ocean adapt
# -------------------- #


# -------------------- #
# packages
# -------------------- #
require(dplyr)
library(readxl)
library(ggplot2)
# -------------------- #


# -------------------- #
# load data
# -------------------- #
nefsc.data <- read.csv("T:/Personal Folders/! FORMER RUMFS EMPLOYEES !/Coleman/wf_new/neus_data.csv", header=TRUE)
# -------------------- #


# -------------------- #
# format data
# -------------------- #
names(nefsc.data) = tolower(names(nefsc.data))
nefsc.data = nefsc.data %>% filter(svspp %in% 106) %>% mutate(season = tolower(season)) %>% 
  rename(salbot = botsalin, tempbot = bottemp, count = abundance) 

# cut to whats below the hudson canyon
source("T:/Personal Folders/! FORMER RUMFS EMPLOYEES !/Coleman/wf_new/create_hudson_canyon_poly.R")

coordinates(nefsc.data) = ~lon+lat
proj4string(nefsc.data) = CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")
x = sp::over(nefsc.data, hud.poly)
nefsc.data = as.data.frame(nefsc.data[!is.na(x),])

# ggplot(nefsc.data2,aes(lon,lat))+geom_point()

# calibration 
# https://www.nefsc.noaa.gov/publications/crd/crd1204/
# https://www.nefsc.noaa.gov/publications/crd/crd1005/crd1005.pdf

# split data to keep the shallow sampled areas
nefsc.inner.data = filter(nefsc.data, year < 2009, depth < 16, stratum < 7000) %>% mutate(survey = 'nefsc.inner')
nefsc.outer.data = filter(nefsc.data, depth >= 16) %>% mutate(survey = 'nefsc.outer')
 
# only grab consistently sampled strata
x = nefsc.outer.data %>% group_by(stratum) %>% summarize(n = n_distinct(year)) %>% arrange(n)
y = nefsc.inner.data %>% group_by(stratum) %>% summarize(n = n_distinct(year)) %>% arrange(n)

nefsc.inner.data = filter(nefsc.inner.data, stratum %in% y$stratum[y$n>11]) # 41 years but most strata sampled <50% -> 37 years across the span
# ggplot(nefsc.inner.data,aes(year))+geom_bar()
# ggplot(nefsc.inner.data,aes(year,stratum))+geom_point()

nefsc.outer.data = filter(nefsc.outer.data, stratum %in% x$stratum[x$n>20]) # 54 years total, went with sampled >39% like did with inner
# -------------------- #

