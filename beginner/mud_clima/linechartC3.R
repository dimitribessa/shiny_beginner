 #usando o canvasJS (09-dez-2019, 00:58h)

# To be called from ui.R
 lineC3Output <- function(inputId, width="100%", height="100%") {
  style <- sprintf("width: %s; height: %s;",
    validateCssUnit(width), validateCssUnit(height))
  
  tagList(
    # Include CSS/JS dependencies. Use "singleton" to make sure that even
    # if multiple lineChartOutputs are used in the same page, we'll still
    # only include these chunks once.
    singleton(tags$head(
      tags$script(src= '.d3/d3.v3.min.js'),
      tags$script(src= "./c3/c3.min.js"),
      tags$link(rel = "stylesheet", type = "text/css", href = "./c3/c3.min.css"),
      tags$script(src="linec3.js")
    )),
    div(id=inputId, class="lineC3", style=style,
      tag("svg", list())
    )
  )
 }

# To be called from server.R
 renderC3 <- function(expr, env=parent.frame(), quoted=FALSE) {
  # This piece of boilerplate converts the expression `expr` into a
  # function called `func`. It's needed for the RStudio IDE's built-in
  # debugger to work properly on the expression.
  installExprFunction(expr, "func", env, quoted)
  
  function() {
    dataframe <- func()
     dataframe
  }
   
 }
