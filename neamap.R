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
db <- odbcConnectAccess2007("C:/Users/kecoleman/Downloads/NEAMAP0044.mdb")
#sqlTables(db)
neamap.catch = sqlFetch(db, "Catch") 
neamap.comments = sqlFetch(db, "Comments") 
neamap.crew = sqlFetch(db, "Crew") 
neamap.cruise = sqlFetch(db, "Cruise") 
neamap.depth.strata = sqlFetch(db, "DepthStrata") 
neamap.habitat = sqlFetch(db, "Habitat")    
neamap.indv = sqlFetch(db, "Individual") 
neamap.pan = sqlFetch(db, "Pan")     
neamap.station = sqlFetch(db, "Station")  
neamap.track = sqlFetch(db, "TrackData")  
neamap.weather = sqlFetch(db, "Weather")   
neamap.wq = sqlFetch(db, "WQ") 
odbcClose(db)
# ------------------------ #
