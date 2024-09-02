#análise exploratória dos dados de Presídios (01-fev-2019, 11:51h)

ui <-
  tags$html(
         tags$head(
         tags$title("Sistema prisonal SC"),
         tags$meta(charset="utf-8"),
         tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css"), # href="bootstrap.min.css")
         tags$link( href="bootstrap.min.css", rel="stylesheet")
      ),  #head
     tags$body(     
  #abas para as diversas páginas
  navbarPage( '',#tags$span(class = 'img-logo'),
  tabPanel('Análise exploratória dos dados',
  tags$div(class = 'container',

   fluidRow(
    column(4,
   tags$div(class = 'ferramenta',
    selectInput('tipo','Tipo de estabelecimento prisional:',
                 choices = c('Todos',unique(infos_pres[,8]))),
    selectInput('sexo','Estabelecimento originalmente destinado a pessoas privadas de liberdade do sexo:',
                 choices = c('Todos',unique(infos_pres[,6])))
            )), #ferramenta , column
     column(8, leafletOutput("map",width="100%",height="480px"))
            ), #row
    hr(),
    fluidRow(
              column(6,
              tags$div(class = 'ferramenta',
              h2("Síntese para Homens:"),
              h4('População carcerária, (dez-2016)'),
              barchartC3('popm'),
              h4('Capacidade carcerária, (dez-2016)'),
              barchartC3('capm'))), #div ferramenta

              column(6,
              tags$div(class = 'ferramenta',
              h2('Síntese para Mulheres:'),
              h4('População carcerária, (dez-2016)'),
              barchartC3('popf'),
              h4('Capacidade carcerária, (dez-2016)'),
              barchartC3('capf'))) #div ferramenta
              ),#row
    hr()
    )#div container
    ) #tabpanel
    )#navbarpage
    
   )#body
   )#html 