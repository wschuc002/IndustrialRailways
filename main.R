# Student: William Schuch & Rik van Berkum
# Team: Geodetic Engineers of Utrecht
# Student#: 901120-751-050 & 931112-059-020
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
#install.packages("raster")

# load the packages
library(raster)
library(sp)
library(rgdal)
library(rgeos)

library(maptools)


# download the data (BONUS)
download.file(url = 'http://www.mapcruzin.com/download-shapefile/netherlands-building-shape.zip',
							destfile = './data/netherlands-building-shape.zip', method = 'auto')
download.file(url = 'http://www.mapcruzin.com/download-shapefile/netherlands-natural-shape.zip',
							destfile = './data/netherlands-natural-shape.zip', method = 'auto')
download.file(url = 'http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip',
							destfile = './data/etherlands-places-shape.zip', method = 'auto')
download.file(url = 'http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip',
							destfile = './data/netherlands-railways-shape.zip', method = 'auto')

NL_buildings <- "./data/netherlands-building-shape.zip"
NL_natural <- "./data/netherlands-building-shape.zip"
NL_places <- "./data/netherlands-building-shape.zip"
NL_railways <- "./data/netherlands-railways-shape.zip"

# unzip the data
unzip(NL_buildings, files = NULL, list = FALSE, overwrite = TRUE,
			junkpaths = FALSE, exdir = "./data/NL_buildings", unzip = "internal",
			setTimes = FALSE)
unzip(NL_natural, files = NULL, list = FALSE, overwrite = TRUE,
			junkpaths = FALSE, exdir = "./data/NL_natural", unzip = "internal",
			setTimes = FALSE)
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
plot(railway_test)

# reproject LatLong
railway_test_LL <- CRS("+proj=longlat +datum=WGS84")
railways.shp <- readShapeLines("./data/NL_railways/railways.shp", verbose=TRUE, proj4string=railway_test_LL)
plot(railways.shp)

# transform to RD New (EPSG:28992)
railway_test_RD <- spTransform(railways.shp , CRS("+init=epsg:28992"))
plot(railway_test_RD)

# write KML file to disk
KML(x=railway_test_LL, filename='./output/railway_test_RD.kml', overwrite=TRUE)
KML(x=railway_test_RD, filename='./output/railway_test_RD.kml', overwrite=TRUE)


# coordinates of two important locations in Wageningen
Campus_Atlas_LL <- c(51.988021, 5.668815)
Busstation_LL <- c(51.969408, 5.667005)

## RGDAL method
NL_Railways <- "./data/NL_railways/railways.shp"
NL_Railways.shp <- readOGR("./data/NL_railways/railways.shp")


ogrInfo(".", "./data/NL_railways/railways.shp")
NL_Railways <- "./data/NL_railways/railways.shp"
NL_Railways.dbf <- "./data/NL_railways/railways.dbf"
ogrInfo(".", NL_Railways.shp)


# # untar lansat data
# untar("./data/LT51980241990098-SC20150107121947.tar.gz", exdir = "./data/LS5")
# untar("./data/LC81970242014109-SC20141230042441.tar.gz", exdir = "./data/LS8")
# 
# # storing tif file paths
# in_LS5_B3="./data/LS5/LT51980241990098KIS00_sr_band3.tif"
# in_LS5_B4="./data/LS5/LT51980241990098KIS00_sr_band4.tif"
# in_LS8_B4="./data/LS8/LC81970242014109LGN00_sr_band4.tif"
# in_LS8_B5="./data/LS8/LC81970242014109LGN00_sr_band5.tif"
# in_cloud_LS5 <- "./data/LS5/LT51980241990098KIS00_cfmask.tif"
# in_cloud_LS8 <- "./data/LS8/LC81970242014109LGN00_cfmask.tif"