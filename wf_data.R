# ------------------ #
# load winter flounder data 
# prep it for GAM
#
# written by: KColeman
# Dec. 2 2017
# ------------------ #


# ------------------ #
# load corrected/formatted data
# ------------------ #
source("T:/Personal Folders/! FORMER RUMFS EMPLOYEES !/Coleman/wf_new/njdep.R")
source("T:/Personal Folders/! FORMER RUMFS EMPLOYEES !/Coleman/wf_new/neamap.R")
# ------------------ #


# ------------------ #
# format data
# ------------------ #
# join data
wf.data = bind_rows(njdep, neamap, nmfs)
# create seasons (winter: Dec,Jan,Feb; spring: Mar,Apr,May; summer: Jun,Jul,Aug; fall: Sep,Oct,Nov)
# create spawning year (grouped by one spawning cycle rather than year)
seasons = as.data.frame(matrix(nrow=12,ncol=2,data=NA))
names(seasons)=c("month","season")
seasons = seasons %>% mutate(month = 1:12, season = c(rep("winter",2),rep("spring",3),rep("summer",3),rep("fall",3),"winter"))
                                            
wf.data = left_join(wf.data, seasons, by="month") %>% mutate(ssb.yr = )
# change projection
# create centers of biomass

# ------------------ #
