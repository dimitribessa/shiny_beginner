 
 #ui leitos (30-ago-21)
 list(
 fluidRow(
  column(8,
         dateInput('data_serie',
                   label = 'Dia:', min = min(names(serie_ocup)), max = max(names(serie_ocup)),
                   value = max(names(serie_ocup))),
         tabsetPanel(type = "tabs", id = 'painel_regs_series',
                     tabPanel("Macrorregião",
                              leafletOutput('mapaleitos_serie_macro', width = '100%') ,
                              br()
                              
                     ), #endpanel macrorregião
                     
                     tabPanel("Região",
                              leafletOutput('mapaleitos_serie_reg', width = '100%') ,
                              br()
                              
                     )#, #endpanel região
                     # tabPanel("Município",
                     #     leafletOutput('mapaleitos_serie_munic', width = '100%') ,
                     #   br()
                     
                     #), #endpanel município
                     # br()
                     
         ) #endTabsetpanel
  ), #endcolumn
  column(4,
         h4('UTI - % de ocupação'),
         
         barverthighOutput('cont_chart_serie', height = '420px')
  )
), #endrow
fluidRow(
  column(2,
         checkboxInput('iscovid_leito', 'Somente leitos UTI COVID', value = TRUE)
  )),
fluidRow(
  
  column(12,
         h4('UTI - Série da ocupação (%)'),
         linerangeOutput('lines_serie', height = '420px')
         #linehighOutput('lines_serie')
  ) #endcolumn  
), #endrow

br(),

fluidRow(
  column(6,
         h4('Série ocupação e totais (UTI)'),
         selectInput("list_serie", "Localidade:",
                     choices= c(levels(dado_hist_mov$macrorregiao.atendimento)), 
                     selected =  c(levels(dado_hist_mov$macrorregiao.atendimento)[1]),
                     multiple = F),
         linerangeOutput('lines_ocup_serie')),
  column(6,
         h4('Tempo médio de ocupação UTI'),
         dateRangeInput('dateRange_serie',
                        label = 'Datas',
                        min = min(names(serie_ocup)), max = max(names(serie_ocup)),
                        start =  min(names(serie_ocup)), end = max(names(serie_ocup))
         ),
         barverthighOutput('chart_tempo_serie'))
 )    #endrow
 ) #endlist
