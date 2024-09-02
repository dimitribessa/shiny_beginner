library('shiny')
library('plotly')
library('leaflet')
library('shinydashboard')

library('dplyr')        #manipulacao de dados - tydiverse
library('stringr')      #funcoes de string  - tydiverse
library('rgeos') #leitura de mapas
library('rgdal') #leitra de mapas
library('RColorBrewer')
library('raster')
library('leaflet')

 load('dadoV8.RData')
 load('sazonalidade.RData')


#funcoes do grafico em linha
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

 # To be called from ui.R
 barC3Output <- function(inputId, width="100%", height="400px") {
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
         tags$script(src= "barchart.js")
    )),
    div(id=inputId, class="c3barchart", style=style,
      tag("svg", list())
    )
  )
 }

  timeC3Output <- function(inputId, width="100%", height="400px") {
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
         tags$script(src= "timechart.js")
    )),
    div(id=inputId, class="c3timechart", style=style,
      tag("svg", list())
    )
  )
 }