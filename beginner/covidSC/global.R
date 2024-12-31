 #carregando os pacotes...
 library('shiny')
 library('shinydashboard')
 #library('shinydashboardPlus')
 library('shinyWidgets')
 #library('plotly')
 library('leaflet')
 library('leaflet.extras')

 library('dplyr')        #manipulação de dados - tydiverse
 library('stringr')      #funções de string  - tydiverse

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

 #carregand dados do boavista

 #carregando os dados
 
 
  load('macro_saude.RData')
 load('mapa_macro.RData')
 load('mapa_regionais.RData')
 load('epid_data.RData')
 load('cod_ufs.RData')
 load('pops_sc.RData')
 load('mapa_associacoes.RData')
 
 #alguns dfs básicos
 #população macrorregioes da saude
 
 load('boavista_server.RData')
 options(warn = -1)
  #load('boavista23.RData')
 
  source('./treating_data.R', local = T, encoding = 'UTF-8')
 
 #dados leitos (15-out-20)
 load('serie_ocup.RData')
 load('dado_hist.RData')

 source('./www/highcharts/barcharthigh.R')
 source('./www/highcharts/barcharthigh2.R')
 source('./www/highcharts/barcharttime.R')
 source('./www/highcharts/barcharttime2.R')
 source('./www/highcharts/barcharthighvert.R')
 source('./www/highcharts/bubblehighchart.R')
 source('./www/highcharts/genderchart.R')
 source('./www/highcharts/barstackedhigh.R')
 source('./www/highcharts/linehighchart.R')
 source('./www/highcharts/timehigh.R')
 source('./www/highcharts/timehighlog.R')
 source('./www/highcharts/linerange.R')
 #carregando funçes dashboard
 source('./funcoes_dashboard.R')

 source('./ui_29mar.R', local = T, encoding = 'UTF-8')
