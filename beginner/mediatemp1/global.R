library('shiny')
library('plotly')
library('leaflet')
library('highcharter')

library('dplyr')        #manipulação de dados - tydiverse
library('stringr')      #funções de string  - tydiverse
#library('rgeos') #leitura de mapas
#library('rgdal') #leitra de mapas
library('RColorBrewer')
library('raster')
library('leaflet')
#library('viridis')
library('rCharts')

load('inpedata.RData')

#Editando as codificações
Encoding(levels(municipiopoly@data$Municipio)) <- 'latin1'
Encoding(levels(municipiopoly@data$ADR)) <- 'latin1'
Encoding(levels(municipiopoly@data$NM_MUNICIP)) <- 'latin1'
