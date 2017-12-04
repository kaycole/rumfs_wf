# -------------- #
# get bathy
# make a polygon to split the data at the hudson canyon
# -------------- #


# -------------- #
# load packages
# -------------- #
library(marmap)
library(rgdal)
# -------------- #


# -------------- #
# get data
# -------------- #
# mab <- getNOAA.bathy(lon1 = -74.5, lon2 = -72.5, lat1 = 39.5, lat2 = 40.5, resolution = 1)
# 
# # Creating color palettes
# blues <- c("lightsteelblue4", "lightsteelblue3",
#            "lightsteelblue2", "lightsteelblue1")
# greys <- c(grey(0.6), grey(0.93), grey(0.99))
# 1
# plot(mab, image = TRUE, land = TRUE, lwd = 0.03,
#      bpal = list(c(0, max(mab), greys),
#                  c(min(mab), 0, blues)))
# # Add coastline
# plot(mab, n = 1, lwd = 0.4, add = TRUE)
# -------------- #


# -------------- #
# make polygon
# -------------- #
# create super basic polygon bounding box
hud.coords = matrix(c(-73.8,40.6,
                      -76,40.6,
                      -76,35,
                      -72.5,35,
                      -72.5,39.6,
                      -73,39.82,
                      
                      -73.2,39.94,
                      -73.34,39.98,
                      
                      -73.55,40.1,
                      -73.75,40.2,
                      -73.8,40.3,
                      -73.8,40.6), 
                       ncol = 2, byrow = TRUE)
hud.coords = as.data.frame(hud.coords)
names(hud.coords)=c("coords.x1","coords.x2")
P1 = Polygon(hud.coords)
hud.poly = SpatialPolygons(list(Polygons(list(P1), ID = "hud")), 
                         proj4string=CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))

# autoplot(mab, geom="contour", mapping=NULL, coast=TRUE)+ 
#   geom_polygon(data = hud.poly, aes(x=coords.x1,y=coords.x2), color = "red", fill=NA)

# plot(mab, image = TRUE, land = TRUE, lwd = 0.03,bpal = list(c(0, max(mab), greys),c(min(mab), 0, blues)))
# plot(mab, n = 1, lwd = 0.4, add = TRUE)
# points(hud.coords$coords.x1, hud.coords$coords.x2,col="red")
# lines(hud.coords$coords.x1, hud.coords$coords.x2,col="red")


rm(hud.coords)
# -------------- #
