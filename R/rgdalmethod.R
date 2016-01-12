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
indrail <- subset(railways, select = type, type == 'industrial')
plot(indrail)

# buffer 1000 meter
railways_buffer <- gBuffer(subset, byid=TRUE, width=1000)
plot(railways_buffer)
# intersect places
railways_inter <- intersect(railways_buffer, places)
plot(railways_inter)














subset <- railways$type=="industrial"
subset
plot(subset)

daf <- railways$type=="disused"
daf
spplot(subset)

names(railways)
railways$type=="rail"
