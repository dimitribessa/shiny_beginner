#carregando as bibliotecas...
 library('reshape2')
 library('data.table')
 library('scales')
 library('dplyr')
 library('RColorBrewer')
 library('stringr')
 library('ggplot2')
 library('maps') #carregar mapas padrao
 library('maptools') #Para confec??o de mapas
 #library('rgeos') #leitura de mapas
 #library('rgdal') #leitra de mapas

 library('plotly')

 library('shiny')
 library('leaflet')



 #lendo os dados
 load('dados.RData')
 #global test
 renderbarC3 <- function(expr, env=parent.frame(), quoted=FALSE) {
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
 
 #!grafico de serie de tempo
 
#funcoes do grafico em linha
 renderC3line <- function(expr, env=parent.frame(), quoted=FALSE) {
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
 
 #adicionado em 18-jul-19 (11:12h)
 #!gr�fico barra nvd3
 discreteChartOutput <- function(inputId, width="100%", height="400px") {
  style <- sprintf("width: %s; height: %s;",
    validateCssUnit(width), validateCssUnit(height))
  
  tagList(
    # Include CSS/JS dependencies. Use "singleton" to make sure that even
    # if multiple lineChartOutputs are used in the same page, we'll still
    # only include these chunks once.
    singleton(tags$head(
      tags$script(src="d3/d3.v3.min.js"),
      tags$script(src="nvd3/nv.d3.min.js"),
      tags$link(rel="stylesheet", type="text/css", href="nvd3/nv.d3.min.css"),
      tags$script(src="discretemultibarchart-binding.js")
    )),
    div(id=inputId, class="nvd3-discretemultibarchart", style=style,
      tag("svg", list())
    )
  )
 }
 
 #!gr�fico vertical barra nvd3
 NVD3vbarchart <- function(inputId, width="100%", height="400px") {
  style <- sprintf("width: %s; height: %s;",
    validateCssUnit(width), validateCssUnit(height))
  
  tagList(
    # Include CSS/JS dependencies. Use "singleton" to make sure that even
    # if multiple lineChartOutputs are used in the same page, we'll still
    # only include these chunks once.
    singleton(tags$head(
      tags$script(src="d3/d3.v3.min.js"),
      tags$script(src="nvd3/nv.d3.min.js"),
      tags$link(rel="stylesheet", type="text/css", href="nvd3/nv.d3.min.css"),
      tags$script(src="vertbarchartNVD3.js")
    )),
    div(id=inputId, class="nvd3-vertbarchart", style=style,
      tag("svg", list())
    )
  )
 }
 
 