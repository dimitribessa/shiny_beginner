library('shiny')
library('plotly')
library('leaflet')
library('ggplot2')      #Gráficos (mais usado)
library('dplyr')        #manipulação de dados - tydiverse
#library('rgeos') #leitura de mapas
#library('rgdal') #leitra de mapas
library('stringr')      #funções de string  - tydiverse
library('magrittr')     #para mudar nome de colunas
library('reshape2')
library('data.table')
library('RColorBrewer')
library('scales')

load('data.RData')


#Editando as codificações
Encoding(levels(municipiopoly@data$Municipio)) <- 'latin1'
Encoding(levels(municipiopoly@data$ADR)) <- 'latin1'
Encoding(levels(municipiopoly@data$NM_MUNICIP)) <- 'latin1'

Encoding(levels(data_pib$municipio)) <- 'latin1'
