# Student: William Schuch & Rik van Berkum
# Team: Geodetic Engineers of Utrecht
# Institute: Wageningen University and Research
# Course: Geo-scripting (GRS-33806)
# Date: 2016-01-11
# Week 2, Lesson 6: Intro to raster

rm(list = ls())  # Clear the workspace!
ls() ## no objects left in the workspace

# load the packages
library(sp)
library(rgdal)
library(rgeos)

# referring to functions in R folder
source("R/prj_string_RD.R")
source("R/colreg.R")

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

# intersects, with 'gIntersects', NOT with 'gIntersection'!!
myintersection <- gIntersects(myplacesRD, buffline, byid = TRUE)
# create a subset of object(s) that intersect
SS_The_City <- subset(myplacesRD, myintersection[TRUE])

# write Shapefile file to disk
dir.create("./output", showWarnings = FALSE)
writeOGR(buffline, "./output", "buffline", driver="ESRI Shapefile", overwrite = TRUE)
writeOGR(SS_The_City, "./output", "SS_The_City", driver="ESRI Shapefile", overwrite = TRUE)
SS_The_City.shp <- readOGR(dsn="./output/SS_The_City.shp", layer="SS_The_City")
The_City_Name <- SS_The_City.shp$name

# visualisation of place(s) inside the buffer
plot(buffline, lty = 3, lwd = 2, col = "blue")
plot(SS_The_City, add= TRUE, lty = 3, lwd = 2, col = "red")

spplot(SS_The_City.shp, zcol = "name",
			 xlim = bbox(SS_The_City.shp)[1, ]+c(-100,100),
			 ylim = bbox(SS_The_City.shp)[2, ]+c(-100,100),
			 xlab = "RD x", ylab = "RD Y",
			 scales= list(draw = TRUE),
			 add = TRUE,
			 sp.layout = SS_The_City.shp)

pts <- list("sp.points", SS_The_City, pch=19, col="red",zcol = "name")
spplot(buffline, zcol = "type",
			 col.regions = colreg,
			 xlim = bbox(SS_The_City)[1, ]+c(-100,100),
			 ylim = bbox(SS_The_City)[2, ]+c(-100,100),
			 xlab = "RD x", ylab = "RD Y",
			 scales= list(draw = TRUE),
			 sp.layout=pts,
			 #sp.layout=SS_The_City.shp,
			 main = "City inside the buffer")

# Name of city: Utrecht
# Population of city: 100000