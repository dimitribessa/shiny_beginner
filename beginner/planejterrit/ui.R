#planejamento territorial (18-dez-2018, 21:24h)
#modificado para simate
ui <-
  tags$html(
         tags$head(
         tags$title("Planejamento Territorial"),
         tags$meta(charset="utf-8"),
         tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css"), # href="bootstrap.min.css")
         tags$link( href="bootstrap.min.css", rel="stylesheet")
      ),  #head
     tags$body(     
  #abas para as diversas páginas
  navbarPage('',
  tabPanel('Indicadores municipais',
  tags$div(class = 'container',
   tags$div(class = 'ferramenta',
    fluidRow(
            column(3,
            radioButtons('opcao', 'Tipos de indicadores:',
            choices = c('Desenvolvimento Humano' = 'idhm',
                        'Vulnerabilidade Social' = 'ivs',
                        'Produção' = 'pib'),selected = 'pib')
            ),#column3
            column(5,
    uiOutput('ui')),#column5
    column(3,
             actionButton("action", label = "Atualizar Mapa"))#column3
   ) #row
   ),#div    
    br(),  
    
    leafletOutput("map",width="100%",height="480px"),
    hr(),
   
    fluidRow( column(4,h4("Quadro Resumo:")), #tableOutput("view")),
              column(6,h4('Ranking:'), vertbarchartC3('graf1'))
              ),#row
    hr(),
    fluidRow( column(6, h4('Comparativo IVS´s'),
               selectInput("ivsI", "IVS´s:",choices = c(names(ivs)[3:22]), selected = names(ivs)[4]),
               plotlyOutput('graf2')),
               column(6, selectInput("cidade", "Município:",choices = c(levels(municipiopoly@data$Municipio)),
                         selected = 'Florianópolis'),
                         selectInput("ivsII", "IVS´s:",choices = c('IVS', names(ivs)[4:6]), selected = 'IVS'),
               plotlyOutput('graf3'))
               ),#row
   titlePanel('Séries de tempo'),
     fluidRow(column(2,
       wellPanel(h3('Variáveis'),
          selectInput('multmunicipios',
                 'Municípios:', choices = c(levels(municipiopoly@data$Municipio)), multiple = TRUE),
          selectInput('varseries',
                  'Indicador:', choices = list('Agropecuária' = 'agropecuaria', 'Indústria' = 'industria',
                                            'Serviço' = 'servico', 'Administração Pública' = 'adm_pub',
                                            'Impostos' = 'imposto','PIB' = 'sum_pib'), selected = 'sum_pib', multiple = TRUE)
        )#wellPanel
        ),
               column(5,lineC3Output('seriesI')),
               column(5,lineC3Output('seriesII'))
               )#row
    )#div container
    ) #tabpanel
    )#navbarpage
    
   )#body
   )#html 