library(raster)
library(sp)
library(rgdal)
library(rgeos)


#railwayspath <- "./data/NL_railways/railways.shp"
?ogrInfo()

railways <- readOGR(dsn="./data/NL_railways", layer="railways")
places <- readOGR(dsn="./data/NL_places", layer="places")
#plot(railways)

# select industrial railways
subset <- railways[railways$type=="industrial"]
# buffer 1000 meter
railways_buffer <- gBuffer(subset, byid=TRUE, width=1000)
# intersect places
intersect(railways_buffer, places)















subset <- railways$type=="industrial"
subset
plot(subset)

daf <- railways$type=="disused"
daf
spplot(subset)

names(railways)
railways$type=="rail"
