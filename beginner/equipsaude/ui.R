#dados de unidades hospitalares (15-jul-19, 11:59h)

ui <-
  tags$html(
         tags$head(
          HTML('<script defer src="https://use.fontawesome.com/releases/v5.0.10/js/all.js"
          integrity="sha384-slN8GvtUJGnv6ca26v8EzVaR9DC58QEwsIk9q1QXdCU8Yu8ck/tL/5szYlBbqmS+"
           crossorigin="anonymous"></script>'),
         tags$title("Unidades de saúde SC"),
         tags$meta(charset="utf-8"),
         tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css"), # href="bootstrap.min.css")
         tags$link( href="bootstrap.min.css", rel="stylesheet")
      ),  #head
     useShinydashboard(),
     tags$body(  
        
  #abas para as diversas páginas
  navbarPage( '',#tags$span(class = 'img-logo'),
  tabPanel('Equipamentos Hospitalares (SC)',
  tags$div(class = 'container',

   leafletOutput("map",width="100%",height="550px"),
    hr(),
    fluidRow(column(4,
   selectInput("equip", "Equipamento:", 
                  choices= c(levels(dado$variable)), selected=levels(dado$variable)[1])),
            column(4,
   selectInput("sit", "Situação:", 
                  choices= c('Todos equipamentos' = 1,'Em uso pelo SUS' = 2, 'Rede privada' = 3), selected='Todos equipamentos')),                
                 p("Fonte: DATASUS 2020"),
                   p('Informações referentes a dezembro/2019')
   ),
   
    br(),
    fluidRow(column(3,checkboxInput('rede', 'Rede Neoplasia', value = FALSE)), #uiOutput('ui')),
             column(3,checkboxInput('rede4', 'Rede Catarata', value = FALSE))),
    hr(),
     fluidRow(
     column(4,
       infoBoxOutput("total_equip", width = NULL)),
     column(4,
       infoBoxOutput("total_equip_sus", width = NULL)),
     column(4,
       infoBoxOutput("total_equip_nsus", width = NULL))  
       ), #endRow
    tags$div(class = 'ferramenta',
    # fluidRow( column(3,h4("Quadro Resumo:"), DT::dataTableOutput("view")),column(6,h4('Equipamentos em uso por Município'), vertbarchartC3('graf1'), offset = 2))
    
    fluidRow( column(3,h4("Quadro Resumo:"), tableOutput("view")),column(6, h4('Equipamentos em uso por Município'),vertbarchartC3('graf1'), offset = 2))
    ) #div ferramenta
      )#div container
    ), #tabpanel
    
    #!leitos / municipio
     source('ui_leitos.R', encoding = 'UTF-8', local = T)$value, #tabpanel
    
    #!leitos / hospital
     #source('ui_leitos_hosp.R', encoding = 'UTF-8', local = T)$value, #tabpanel
    
    
  tabPanel( 'Estabelecimentos Hospitalares (SC)',
  tags$div(class = 'container',  
     
  # Give the page a title  
  #titlePanel('Painel dinâmico'),       
    # Create a spot for the barplot
    leafletOutput("mapii",width="100%",height="550px"),
    hr(),
    fluidRow(column(4,selectInput("desc", "Tipo CNES:", 
                  choices= c(levels(dadosCNES$Desc_CNES)), selected=levels(dadosCNES$Desc_CNES)[2])
                   ),
            column(4,
    selectInput("gestao", "Gestão SUS:", 
                  choices= c('Sim' = 1,'Não' = 0, 'Todos'), selected='Sim')),                
                  p("Fonte: DATASUS 2020"),
                   p('Informações referentes a dezembro/2019')
   ), 
    br(),
    fluidRow(column(3,checkboxInput('rede2', 'Rede Neoplasia', value = FALSE)),
             column(3,checkboxInput('rede3', 'Rede Catarata', value = FALSE))),
   br(),
   tags$div(class ='ferramenta',
    fluidRow(column(3,h4("Quadro Resumo:"), tableOutput("viewii")),column(6, h4('Distribuição dos estabelecimentos nos municípios'), offset = 3, vertbarchartC3('grafII')))
          )#div ferramenta
     )#div container
    ) #tabpanel  
    )#navbarpage
    
   )#body
   )#html 