library("shiny")
library("shinyjs")
library("tidyverse")
library("plotly")
library("shinydashboard")
library("DT")
library("countrycode")
library("markdown")
library("htmltools")

options(shiny.sanitize.errors = FALSE)

wineData <- read.csv("./data/winemag-data-130k-v2.csv")

