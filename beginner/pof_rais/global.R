 #carregando os pacotes...
 library('shiny')
 library('shinydashboard')
 library('shinydashboardPlus')
 library('shinyWidgets')
 #library('plotly')
 library('leaflet')
 library('leaflet.extras')

 library('dplyr')        #manipulação de dados - tydiverse
 library('stringr')      #funções de string  - tydiverse
 #library('rgeos') #leitura de mapas
 #library('rgdal') #leitra de mapas
 library('sf') #plot maps
 library('magrittr')     #para mudar nome de colunas
 library('reshape2')
 library('data.table')
 library('RColorBrewer')
 #library('scales')
 #library('raster')
 #library('xts')
 #library('dygraphs')
 #library('highcharter')
 library('ggplot2')
 
 #para predições
 library('forecast')
 

 #carregand dados
 load('ocup_salariosc.RData')
 load('pof_shiny.RData')
 
 source('./treating_data.R', local = T, encoding = 'UTF-8')
 options(warn = -1)
 

 source('./www/highcharts/barcharthigh.R')
 source('./www/highcharts/barcharthigh2.R')
 source('./www/highcharts/barcharttime.R')
 source('./www/highcharts/barcharthighvert.R')
 source('./www/highcharts/barcharthighvert2.R')
 source('./www/highcharts/bubblehighchart.R')
 source('./www/highcharts/genderchart.R')
 source('./www/highcharts/barstackedhigh.R')
 source('./www/highcharts/linehighchart.R')
 source('./www/highcharts/timehigh.R')
 source('./www/highcharts/timehighlog.R')
 source('./www/highcharts/linerange.R')
 
 #carregando funçes dashboard
 source('./funcoes_dashboard.R')
 
