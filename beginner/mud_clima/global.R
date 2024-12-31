#carregando as bibliotecas...
 library('reshape2')
 library('data.table')
 library('scales')
 library('dplyr')
 library('RColorBrewer')
 library('stringr')
 library('ggplot2')
 library('magrittr')     #para mudar nome de colunas
 
 library('maps') #carregar mapas padrao
 #library('maptools') #Para confecção de mapas
 #library('rgeos') #leitura de mapas
 #library('rgdal') #leitra de mapas
 library('raster')
 library('sp')
 library(scales)
 library(lattice)


 library('shiny')
 library('leaflet')
 library('leaflet.extras')
 library('leaflet.minicharts')
 library('manipulateWidget')

 #carregando os dados...
 
 load('shinydata1.RData')
 load('shinydata2.RData')
 load('shinydata3.RData')
 
 #carregando funcçoes extras
 source('./highbar.R') #gráfico do highchart
 source('./linechart.R') #gráfico linha do canvas

 