## This script loads all of the necessary packages for the gymnastics case study
## and reads in the raw gymnastics score files stored in the data folder and 
## downloaded from https://github.com/ucsas/gym2024data/tree/main/cleandata

library(knitr)
library(plotly)
library(scales)
library(DT)
library(leaflet)
library(gganimate)
library(corrplot)
library(GGally)
library(ggmap)
library(shiny)
library(MASS)
library(lme4)
library(merTools)
library(arm)
library(pROC)
library(MLmetrics)
library(viridis)
library(RSelenium)
library(rvest)
library(randomForest)
library(FNN)
library(caret)
library(pls)
library(lubridate)
library(stringr)
library(devtools)
library(splines)
library(RecordLinkage)
library(rsconnect)
library(tidyverse)
library(pubtheme)

# load the libraries for parallel processing
library(doSNOW)
library(foreach)
library(parallel)

# read in older and newer gymnastics datasets
in_earlier_scores <- read.csv("Case_Study_1-Gymnastics/data/data_2017_2021.csv")
in_later_scores   <- read.csv("Case_Study_1-Gymnastics/data/data_2022_2023.csv")
