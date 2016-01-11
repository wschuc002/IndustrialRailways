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

# download the data (BONUS)

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