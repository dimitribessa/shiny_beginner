 #ui incidência
  list(
  fluidRow(
           column(6, offset = 6,
            sliderInput("range_incid", label = h3("Dia"),min(data_ufs[,1], na.rm = T),
                         max(data_ufs[,1], na.rm = T), value = max(data_ufs[,1], na.rm = T), step = 1,
                  animate = FALSE)
            )
     ), #endrow 
           
  tabsetPanel(type = "tabs", id = 'painel_inci',    
      tabPanel("País",leafletOutput('mapa_inci')
        ),
      tabPanel('SC',leafletOutput('mapa_incii')
    )),
    
    hr(),
   # verbatimTextOutput('teste'),
    fluidRow(
             
            column(6,
                   h4('Tx. Incidência por Estado*'), 
                   radioButtons('incid_estado',label = '', choices = c('Confirmados' = 1,'Óbitos' = 2), selected = 1,
     inline = T),
     barhighOutput2('rankbar'),
                   p('*por 100.000 habitantes')),
            column(6,
                   h4('Tx. Incidência por Município/SC*'),
                   radioButtons('incidmunicipio',label = '', choices = c('Confirmados' = 1,'Óbitos' = 2 ), selected = 1,
     inline = T),
    barhighOutput2('rankbarII'),
                   p('*por 100.000 habitantes'))       
                   ),#endrow
    fluidRow(
             
            column(6,
                  h4('Série das Incidências por Estado*'),
                  p('dias equalizados'),
                    pickerInput("list_estado", "Estados:",
                  choices= c(levels(data_ufs$UFs)), selected = c('Santa Catarina', 'Rio de Janeiro'),
                  options = list(`actions-box` = TRUE, `none-selected-text` = "Selecionar um estado"),
                  multiple = T),
                   linehighOutput('linechartI'),
                   hr(),
                  h4('Série das Incidências por Estado*'),
                  p('por data'),
                  br(),
                    timehighOutput('timechartII'),
                   p('*por 100.000 habitantes')
                   ), #endcolumn
            column(6,
                  h4('Série das Incidências por Município*'),
                  p('dias equalizados'),
                   pickerInput("lista_municipio", "Municípios:",
                            choices= listagem_municipio, selected = c('Florianópolis', 'Joinville'),
                            options = list(`actions-box` = TRUE, `none-selected-text` = "Selecionar um município"),
                            multiple = T),
                   linehighOutput('linechartmunI'),
                   hr(),
                  h4('Série das Incidências por municipio*'),
                  p('por data'),
                  br(),
                    timehighOutput('timechartmunII'),
                   p('*por 100.000 habitantes')
                   )
                 
                   )#endrow
                   ) #end list