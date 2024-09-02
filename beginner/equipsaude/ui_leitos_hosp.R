 tabPanel('Leitos (SC)',
  tags$div(class = 'container',

   leafletOutput("map_leito_hosp",width="100%",height="550px"),
    hr(),
    fluidRow(column(4,
   selectInput("leito_hosp", "Tipo de leitos:", 
                  choices= c(levels(dadosLEITOS2$variable)), selected=levels(dadosLEITOS2$variable)[1])),
            column(4,
   selectInput("cnes3", "Estabelecimento saúde:", 
                  choices= c('Todos',levels(dadosLEITOS2$desc_cnes)), selected='Todos'),
   radioButtons("sus_hosp", label = 'Tipo estabelecimento', 
                  choices= list('Todos' = 1,'SUS' = 2, 'Privado' = 3), selected= 2)),  
                   p("Fonte: DATASUS 2020"),
                   p('Informações referentes a dezembro/2019')
   ),    
   
    br(),
    tags$div(class = 'ferramenta',
    # fluidRow( column(3,h4("Quadro Resumo:"), DT::dataTableOutput("view")),column(6,h4('Equipamentos em uso por Município'), vertbarchartC3('graf1'), offset = 2))
    
    fluidRow( column(3,h4("Quadro Resumo:"), tableOutput("view_leito_hosp")),column(6, h4('Leitos por Município'),vertbarchartC3('graf_leito_hosp'), offset = 2))
    ) #div ferramenta
      )#div container
    )