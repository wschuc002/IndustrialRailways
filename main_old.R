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

# load the packages (On Windows)
install.packages(c("raster","maptools"))

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

## MAPTOOLS method

# read shapefile
railway_test <- readShapeSpatial("./data/NL_railways/railways.shp")

# plot shapefile
#plot(railway_test)

# reproject LatLong
railway_test_LL <- CRS("+proj=longlat +datum=WGS84")
railways.shp <- readShapeLines("./data/NL_railways/railways.shp", verbose=TRUE, proj4string=railway_test_LL)
#plot(railways.shp)

# transform to RD New (EPSG:28992)
railway_test_RD <- spTransform(railways.shp , CRS("+init=epsg:28992"))
#plot(railway_test_RD)

# write KML file to disk
dir.create("./output")
KML(x=railway_test_LL, filename='./output/railway_test_RD.kml', overwrite=TRUE)
KML(x=railway_test_RD, filename='./output/railway_test_RD.kml', overwrite=TRUE)


## RGDAL method
NL_Railways <- "./data/NL_railways/railways.shp"
NL_Railways.shp <- readOGR("./data/NL_railways/railways.shp")

ogrInfo(".", "./data/NL_railways/railways.shp")
NL_Railways <- "./data/NL_railways/railways.shp"
NL_Railways.dbf <- "./data/NL_railways/railways.dbf"
ogrInfo(".", NL_Railways.shp)

# RGDALmethod_Rik
#source("R/rgdalmethod.R")
