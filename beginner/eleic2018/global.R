#versao 13-out-2018 (18:50h)
library('shiny')
library('plotly')
library('leaflet')
library('ggplot2')      #Gráficos (mais usado)
library('dplyr')        #
#library('rgeos') #leitura de mapas (retirado em 2024)
#library('rgdal') #leitra de mapas (retirado em 2024)
library('stringr')      
library('magrittr')     #para mudar nome de colunas
library('reshape2')
library('data.table')
library('RColorBrewer')
library('scales')

load('dados_eleic.RData')

#Editando as codificações
Encoding(levels(municipiopolyii@data$Municipio)) <- 'latin1'
Encoding(levels(municipiopolyii@data$ADR)) <- 'latin1'
Encoding(levels(municipiopolyii@data$NM_MUNICIP)) <- 'latin1'

