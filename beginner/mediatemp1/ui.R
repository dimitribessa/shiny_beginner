#versão 14-dez-2018 (22:32h)

# Use a fluid Bootstrap layout
ui <-  tags$html(
         tags$head(
         tags$meta(charset="utf-8"),
         tags$meta(name="viewport", content="width=device-width, initial-scale=1.0"),
         tags$title("Registros temperatura"),
         tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css"), # href="bootstrap.min.css")
         tags$link( href="bootstrap.min.css", rel="stylesheet")
      ),  #head
     tags$body(        
  #abas para as diversas páginas
  navbarPage(" ",
  tabPanel('Temperatura',
   tags$div(class = 'container',
    fluidRow(
    column(5,
     leafletOutput("map",width="100%",height="480px")),
    column(7,
      fluidRow(
        #!não esquecer de colocar a lista de municípios
      	column(6, selectInput("municipio", "Municípios:", c("", levels(municipiopoly@data$Municipio)), selected="Gaspar", multiple=F, width="100%")),
				column(6, selectInput("var", "Variável:", c('Temperatura'),  width="100%"))
      ), #fluidRow
        highchartOutput("Chart1"),
      tags$p('Nota: as barras são referentes às medias dos valores máximos e dos mínimos registrados em determinados municípios. As linhas representam somente aos valores médios registrados'),
      tags$p('Fonte: INPE (Instituto Nacional de Pesquisas Espaciais).')
      )#column7
      )#fluidRow
       
      )#tagdiv
   ) #tabpanel   Inicial
   ) #navbarPage 
   
  )#body
  ) #html
  