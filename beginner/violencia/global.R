# Any code in this file is guaranteed to be called before either
# ui.R or server.R
#carregando as bibliotecas...
library('reshape2')
library('data.table')
library('scales')
library('dplyr')
library('RColorBrewer')
library('stringr')
library('ggplot2')
library('magrittr')

library('shiny')
library('leaflet')

 load('data.RData')
 source("multibarchart.R")

Encoding(levels(all_data$RENDA)) <- 'latin1'
Encoding(names(all_data)) <- 'UTF-8'
Encoding(levels(all_data$IDADE)) <- 'latin1'
Encoding(levels(all_data$RACACOR)) <- 'latin1'
Encoding(levels(all_data$ESC)) <- 'latin1'

