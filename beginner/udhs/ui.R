 #ui
 
ui <-
  tags$html(
         tags$head(
         tags$title("UDHs RM Florianópolis"),
         tags$meta(charset="utf-8"),
         tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css"), # href="bootstrap.min.css")
         #tags$link(rel = "stylesheet", type = "text/css", href = "style.css"), # href="bootstrap.min.css")
         tags$link( href="bootstrap.min.css", rel="stylesheet")
      ),  #head
     tags$body(      
      navbarPage("", 
      tabPanel("Mapa Interativo",

      # If not using custom CSS, set height of leafletOutput to a number instead of percent
      leafletOutput("map",width="80%",height="450px"),
     hr(),
  fluidRow(
   column(5,
    tags$div(class = 'ferramenta',
     h2('Componentes do IVS'),barchartC3('grafI')) #end div
    )), #end column row

      # Shiny versions prior to 0.11 should use class = "modal" instead.
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto",

        h2("Explorador de Dados"),

        selectInput("color", "Variável", vars),
        textInput("text", "Busca Item \n(a ser trabalhado)", value = ""),
        actionButton('atualizar',label = 'Atualizar')
        )

   )# fechamento do tabpanel do mapa interativo

    ) #end panel mapa interativo
    
   ) #body
  ) #html