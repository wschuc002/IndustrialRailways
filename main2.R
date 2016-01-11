# Student: William Schuch & Rik van Berkum
# Team: Geodetic Engineers of Utrecht
# Institute: Wageningen University and Research
# Course: Geo-scripting (GRS-33806)
# Date: 2016-01-11
# Week 2, Lesson 6: Intro to raster

rm(list = ls())  # Clear the workspace!
ls() ## no objects left in the workspace

# referring to functions in R folder
#source("R/ndviCalc.R")
#source("R/ndviFilt.R")

# load the packages
library(raster)
library(sp)
library(rgdal)
library(rgeos)
library(maptools)

getwd()

# download the data (BONUS)
dir.create("./data")
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

## RGDAL method
NL_Railways <- "./data/NL_railways/railways.shp"
NL_Railways.shp <- readOGR(dsn="./data/NL_railways/railways.shp", layer="railways")

SS <- subset(NL_Railways.shp, type == "industrial")
plot(SS)

prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555
										 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000
										 +ellps=bessel +towgs84=565.2369,50.0087,465.658,
										 -0.406857330322398,0.350732676542563,-1.8703473836068,
										 4.0812 +units=m +no_defs")

mylinesRD <- spTransform(SS, prj_string_RD)

buffline <- gBuffer(mylinesRD , width=1000, quadsegs=500, byid = TRUE)
plot(buffline, lty = 3, lwd = 2, col = "blue")
plot(mylinesRD, add= TRUE, lty = 3, lwd = 2, col = "red")

NL_Places <- "./data/NL_railways/places.shp"
NL_Places.shp <- readOGR(dsn="./data/NL_places/places.shp", layer="places")

myplacesRD <- spTransform(NL_Places.shp, prj_string_RD)

plot(myplacesRD, add= TRUE)
