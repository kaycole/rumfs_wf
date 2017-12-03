#---------------------------#
# this script is looking at the NEAMAP data
# for winter flounder
#---------------------------#

#---------------------------#
# packages
#---------------------------#
require(dplyr)
require(RODBC)
#---------------------------#

# ------------------------ #
# load data
# ------------------------ #
db <- odbcConnectAccess2007("T:/Personal Folders/! FORMER RUMFS EMPLOYEES !/Coleman/wf_new/NEAMAP0044.mdb")
#sqlTables(db)
neamap.catch = sqlFetch(db, "Catch") 
neamap.wq = sqlFetch(db, "WQ") # temp, salinity, etc.
neamap.station = sqlFetch(db, "Station") # date, location, etc. 
#neamap.comments = sqlFetch(db, "Comments") 
#neamap.crew = sqlFetch(db, "Crew") 
#neamap.cruise = sqlFetch(db, "Cruise") 
#neamap.depth.strata = sqlFetch(db, "DepthStrata") 
#neamap.habitat = sqlFetch(db, "Habitat") # sand/ SAV etc.    
#neamap.indv = sqlFetch(db, "Individual") # individual fish info
#neamap.pan = sqlFetch(db, "Pan")     
#neamap.track = sqlFetch(db, "TrackData")  
#neamap.weather = sqlFetch(db, "Weather")   
odbcClose(db)
# ------------------------ #


# ------------------------ #
# join tables
# ------------------------ #
# transform wq table first
neamap.wq = neamap.wq %>% 
  filter(LAYER %in% 'B') %>% 
  group_by(STATION) %>% 
  summarise(CTD_SAMPLE_TIME = first(Time),
            CTD_SAMPLE_DEPTH = first(SAMPLE_DEPTH), 
            DO = ifelse(length(VALUE[PARAMETER %in% 'DO'])>0,VALUE[PARAMETER %in% 'DO'],NA),
            PS = ifelse(length(VALUE[PARAMETER %in% 'PS']>0),VALUE[PARAMETER %in% 'PS'],NA),
            SA = ifelse(length(VALUE[PARAMETER %in% 'SA']>0),VALUE[PARAMETER %in% 'SA'],NA),
            WT = VALUE[PARAMETER %in% 'WT']) %>% as.data.frame()
  
neamap.data = left_join(neamap.catch, dplyr::select(neamap.station, STATION,DATE,TowBegin,TowEnd,DepthBeg,
                                                    DepthEnd,DepthStratum,DURATION,VSPEED,VSpeedGPS,
                                                    TOWDIST,TowDistTrack,LATITUDE_START,LONGITUDE_START,
                                                    LATITUDE_END,LONGITUDE_END), by = "STATION") %>%
  left_join(.,neamap.wq, by = "STATION") %>% rowwise %>%
  mutate(date = as.Date(sapply(strsplit(as.character(TowBegin)," "), head, 1),format="%Y-%m-%d"),
         year = as.numeric(format(date, format = "%Y")),
         month = as.numeric(format(date, format = "%m"))) %>% 
  transmute(lon = mean(LONGITUDE_START, LONGITUDE_END),
         lat = mean(LATITUDE_START, LATITUDE_END),
         depth = mean(DepthBeg, DepthEnd)) %>% as.data.frame()

usa <- map_data("usa")
ggplot(neamap.data,aes(lon,lat))+geom_point()+
  geom_polygon(data = usa, aes(x=long, y = lat, group=group), fill="forestgreen")+
  coord_fixed(xlim = c(-76,-70.5), ylim = c(37.5,42.2), ratio = 1.3)+theme_bw()
# ------------------------ #
