# Student: William Schuch & Rik van Berkum
# Team: Geodetic Engineers of Utrecht
# Institute: Wageningen University and Research
# Course: Geo-scripting (GRS-33806)
# Date: 2016-01-11
# Week 2, Lesson 6: Intro to raster

rm(list = ls())  # Clear the workspace!
ls() ## no objects left in the workspace

# referring to functions in R folder
source("R/prj_string_RD.R")

# load the packages
library(sp)
library(rgdal)
library(rgeos)

getwd()

# download the data (BONUS)
dir.create("./data", showWarnings = FALSE)
download.file(url = 'http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip',
							destfile = './data/netherlands-places-shape.zip', method = 'auto')
download.file(url = 'http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip',
							destfile = './data/netherlands-railways-shape.zip', method = 'auto')

NL_places <- "./data/netherlands-places-shape.zip"
NL_railways <- "./data/netherlands-railways-shape.zip"

# unzip the data
unzip(NL_places, files = NULL, list = FALSE, overwrite = TRUE,
			junkpaths = FALSE, exdir = "./data/NL_places", unzip = "internal",
			setTimes = FALSE)
unzip(NL_railways, files = NULL, list = FALSE, overwrite = TRUE,
			junkpaths = FALSE, exdir = "./data/NL_railways", unzip = "internal",
			setTimes = FALSE)

# read the data
NL_Railways.shp <- readOGR(dsn="./data/NL_railways/railways.shp", layer="railways")
NL_Places.shp <- readOGR(dsn="./data/NL_places/places.shp", layer="places")

# create a subset of industrial railways
SS <- subset(NL_Railways.shp, type == "industrial")

# transform to RD new
mylinesRD <- spTransform(SS, prj_string_RD)
myplacesRD <- spTransform(NL_Places.shp, prj_string_RD)

# create a 1000m buffer around the subset
buffline <- gBuffer(mylinesRD , width=1000, quadsegs=500, byid = TRUE)

# intersection
myintersection <- gIntersection(buffline, myplacesRD, byid = TRUE)
myintersection2 <- intersect(buffline, myplacesRD)


# visualisation of place(s) inside the buffer
plot(buffline, lty = 3, lwd = 2, col = "blue")
plot(mylinesRD, add= TRUE, lty = 3, lwd = 2, col = "red")

plot(myplacesRD, add= TRUE)
plot(myintersection, col="blue4")

spplot(myintersection, zcol="coords", col.regions = "red",
			 xlim = bbox(buffline)[1, ]+c(-0.01,0.01),
			 ylim = bbox(buffline)[2, ]+c(-0.01,0.01),
			 scales= list(draw = TRUE))

myintersection

# Name of city: Utrecht
# Population of city: 100000

# write Shapefile file to disk
dir.create("./output", showWarnings = FALSE)
writeOGR(buffline, "./output", "buffline", driver="ESRI Shapefile")


point_data <- data.frame(Name = "City", row.names="1")
point_data
mypointdf <- SpatialPointsDataFrame(myintersection, point_data)
mypointdf

writeOGR(mypointdf, "./output", "mypointdf", driver="ESRI Shapefile")
