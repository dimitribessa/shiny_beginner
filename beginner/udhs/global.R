#carregando as bibliotecas...
 library('reshape2')
 library('data.table')
 library('scales')
 library('dplyr')
 library('RColorBrewer')
 library('stringr')
 library('ggplot2')
 library('maps') #carregar mapas padrao
 library('maptools') #Para confecção de mapas
 #library('rgeos') #leitura de mapas
 #library('rgdal') #leitra de mapas

 library('plotly')

 library('shiny')
 library('leaflet')

# Any code in this file is guaranteed to be called before either

 load('data.RData')
# ui.R or server.R
 #global test
 renderC3 <- function(expr, env=parent.frame(), quoted=FALSE) {
  # Convert expr to a function
  func <- shiny::exprToFunction(expr, env, quoted)
  # installExprFunction(expr, "func", env, quoted) #mesma coisa, de modo antigo
  function() {
    value <- func()
    value
  }
 }

 # To be called from ui.R
 barchartC3 <- function(inputId, width="100%", height="400px") {
  style <- sprintf("width: %s; height: %s;",
    validateCssUnit(width), validateCssUnit(height))
  
  tagList(
    # Include CSS/JS dependencies. Use "singleton" to make sure that even
    # if multiple lineChartOutputs are used in the same page, we'll still
    # only include these chunks once.
    singleton(tags$head(
         tags$link( href="c3/c3.min.css", rel="stylesheet"),
         tags$script(src = 'https://d3js.org/d3.v5.js'),
         tags$script(src = 'c3/c3.min.js'),
         tags$script(src= "barchartC3.js")
    )),
    div(id=inputId, class="barchartC3", style=style,
      tag("svg", list())
    )
  )
 }
 
 #barra invertida
  # To be called from ui.R
 vertbarchartC3 <- function(inputId, width="100%", height="400px") {
  style <- sprintf("width: %s; height: %s;",
    validateCssUnit(width), validateCssUnit(height))

  tagList(
    # Include CSS/JS dependencies. Use "singleton" to make sure that even
    # if multiple lineChartOutputs are used in the same page, we'll still
    # only include these chunks once.
    singleton(tags$head(
         tags$link( href="c3/c3.min.css", rel="stylesheet"),
         tags$script(src = 'https://d3js.org/d3.v5.js'),
         tags$script(src = 'c3/c3.min.js'),
         tags$script(src= "vertbarchartC3.js")
    )),
    div(id=inputId, class="vertbarchartC3", style=style,
      tag("svg", list())
    )
  )
 }

 # To be called from ui.R
 lineC3Output <- function(inputId, width="100%", height="400px") {
  style <- sprintf("width: %s; height: %s;",
    validateCssUnit(width), validateCssUnit(height))
  
  tagList(
    # Include CSS/JS dependencies. Use "singleton" to make sure that even
    # if multiple lineChartOutputs are used in the same page, we'll still
    # only include these chunks once.
    singleton(tags$head(
         tags$link( href="c3/c3.min.css", rel="stylesheet"),
         tags$script(src = 'https://d3js.org/d3.v5.js'),
         tags$script(src = 'c3/c3.min.js'),
         tags$script(src= "testeshinyjs2.js")
    )),
    div(id=inputId, class="testeshiny", style=style,
      tag("svg", list())
    )
  )
 }