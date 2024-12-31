 #usando highchart (16-dez-2019, 15:28h)
# To be called from ui.R
 barhightimeOutput <- function(inputId, width="100%", height="100%") {
  style <- sprintf("width: %s; height: %s;",
    validateCssUnit(width), validateCssUnit(height))
  
  tagList(
    # Include CSS/JS dependencies. Use "singleton" to make sure that even
    # if multiple lineChartOutputs are used in the same page, we'll still
    # only include these chunks once.
    singleton(tags$head(
     tags$script( src="https://code.highcharts.com/highcharts.js"),
     tags$script( src="https://code.highcharts.com/highcharts-more.js"),
     tags$script( src="https://code.highcharts.com/modules/exporting.js"),
     tags$script( src="https://code.highcharts.com/modules/export-data.js"),
     tags$script( src="https://code.highcharts.com/modules/accessibility.js"),
      tags$script(src="./JS/barcharttime.js")
    )),
    div(id=inputId, class="barcharttime", style=style,
      tag("svg", list())
    )
  )
 }
 