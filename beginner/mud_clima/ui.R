 #teste slider (17-nov-019, 15:57h)

 ui <-
  tags$html(
         tags$head(
         tags$title("Cenário Futuro"),
         tags$meta(charset="utf-8"),
         tags$meta(name="viewport", content="width=device-width, initial-scale=1.0"),
         tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css"), # href="bootstrap.min.css")
         tags$link(rel = "stylesheet", type = "text/css", href = "./css_slider/style.css"), # href="bootstrap.min.css")
         tags$link(rel = "stylesheet", type = "text/css", href = "./css_slider/css_comparsion.css"),
         tags$link( href="bootstrap.min.css", rel="stylesheet")
      ),  #head
     tags$body(     
  #abas para as diversas páginas
  navbarPage( '',#tags$span(class = 'img-logo'),
  tabPanel('Análise exploratória dos dados',
 
  fluidRow(
   column(2,
   tags$div(id = "controlss",
    radioButtons("periodo", label = h4("Período do ano:"),
    choices = list("Verão" = 1, "Outono" = 2, "Inverno" = 3, 'Primavera' = 4),
    selected = 1), #end radiobuttons
    selectInput("variavelI", label = h4("Variável:"),
    choices = list("Temperatura Média" = 1, "Temperatura Máxima" = 2,
                   "Temperatura Mínima" = 3, "Precipitação Acumulada Média" = 4,
                   "Precipitação Diária Média" = 5),
    selected = 1), #end radiobuttons
    sliderInput("decimal", "Transparência:",
                  min = 0, max = 1,
                  value = 0.5, step = 0.1),
    hr(),
    
    h3('Mapa esquerdo:'),
     
     selectInput('anos_ant', label = h4('Anos:'),
                        choices = list('1981-2010' = 14,'2011-2040' = 15,
                        '1976-1980' = 7, '1981-1985' = 8, 
                        '1986-1990' = 9, '1991-1995' = 10, '1996-2000' = 11,
                        '2001-2005' = 12, '2006-2010' = 13,
                                       '2011-2015' = 1,
                                       '2016-2020' = 2,
                                       '2021-2025' = 3,
                                       '2026-2030' = 4,
                                       '2031-2035' = 5,
                                       '2036-2040' = 6
                                        ),
                        selected = 7
               ), #selectinput
     radioButtons("modeloI", label = h4("Modelo:"),
       choices = list("RCP 4.5" = 1, "RCP 8.5" = 2),
       selected = 1),
    hr(),  
    h3('Mapa direito:'),
   
    
   selectInput('anos_post', label = h4('Anos:'),
                        choices = list('1981-2010' = 14,'2011-2040' = 15,
                        '1976-1980' = 7, '1981-1985' = 8, 
                        '1986-1990' = 9, '1991-1995' = 10, '1996-2000' = 11,
                        '2001-2005' = 12, '2006-2010' = 13,
                                       '2011-2015' = 1,
                                       '2016-2020' = 2,
                                       '2021-2025' = 3,
                                       '2026-2030' = 4,
                                       '2031-2035' = 5,
                                       '2036-2040' = 6
                                        ),
               selected = 4),  #selectinput
   radioButtons("modeloII", label = h4("Modelo:"),
    choices = list("RCP 4.5" = 1, "RCP 8.5" = 2),
    selected = 1), #end radiobuttons
   # checkboxInput("checkbox", label = "Valores em diferença", value = FALSE), 
               tags$span( style = "display: 'inline'",
        actionButton('modal_report','Sobre os dados.')
        ),
                p('Fonte: GIZ/MMA/INPE (2019)')
   ) #enddiv
   ), #column
  column(10,

 tags$div(class = "ba-slider",
   leafletOutput(outputId = 'map', width = '100%',height="700px"),
   tags$div(class = 'resize', style = 'width: 100%',
   leafletOutput(outputId ='mapii', width = '100%',height="700px")
   ), #div resize
   tags$span(class = 'handle')
   )  #div ba-slider
    )#column
    )#fluidRow
 

  
  ),#end panel  inicial
    tabPanel('Municípios',
   tags$div(class = 'container',
    fluidRow(
    column(6,
     selectInput("meses", label = "Mês:",
       choices = list("Jan" = 1, "Fev" = 2, "Mar" = 3,
                      "Abr" = 4, "Maio" = 5, "Jun" = 6,
                      "Jul" = 7, "Ago" = 8, "Set" = 9,
                      "Out" = 10, "Nov" = 11, "Dez" = 12), 
       selected = 1),
     leafletOutput("mapmedia",width="100%",height="480px")),
    column(6,
      fluidRow(
        #!não esquecer de colocar a lista de municípios
      	column(3, selectInput("municipio", "Municípios:", c("", levels(municipiopoly@data$Municipio)), selected="Gaspar", multiple=F, width="100%")),
				column(3, selectInput("vari", "Variável:", c('Temperatura' = 1, 'Precipitação' = 2),  width="100%")),
        column(3,
         selectInput('anos_media', label = 'Anos:',
                        choices = list('2011-2015' = 1,
                                       '2016-2020' = 2,
                                       '2021-2025' = 3,
                                       '2026-2030' = 4,
                                       '2031-2035' = 5,
                                       '2036-2040' = 6),
               selected = 4)),
        column(3, selectInput("modeloIII", "Modelo:", list('RCP 4.5' = 1,
                                                           'RCP 8.5' = 2),  width="100%"))
      ), #fluidRow
       uiOutput('grafico')
      
      )#column6
      )#fluidRow
       
      )#tagdiv
   ) #tabpanel municiios
 ) #navbarpage
 
 ),#endbody 
  #tags$script(src = "./js/jquery-2.1.1.js"),
  #tags$script(src = "./js/jquery.mobile.custom.min.js"),
  tags$script(src = "./js/jquerycomparsion.js"),
  #tags$script(src = "https://cdn.jsdelivr.net/npm/@herrfugbaum/cato@latest/dest/cato.min.js"),
  tags$script(src = "./js/main.js")
  
 )#html
 
