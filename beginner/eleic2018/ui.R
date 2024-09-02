#ui das eleições 2018  (27-fev-2019, 10:20h)

ui <-  fluidPage(  
         tags$head(
         tags$title("Resultados eleições"),
         tags$meta(charset="utf-8")#,
       #  tags$link(rel = "stylesheet", type = "text/css", href = "style.css"), # href="bootstrap.min.css")
         #includeCSS('www/style.css'),
         #tags$link( href="bootstrap.min.css", rel="stylesheet")
         #includeCSS('www/style.css')
      ),  #head
      
      tags$body( 
  #abas para as diversas páginas
  navbarPage("Página em desenvolvimento",
  tabPanel('Mapa das eleições. 2018.',

  tags$div(class = 'container',
  # Give the page a title  
  titlePanel('Santa Catarina'),       
    fluidRow(
     selectInput("categoria", "Cargo:", choices =  names(varis)),
     #   br(),
     selectInput("color", "Candidato:",choices = varis[[1]])
   ),
   radioButtons("radio", "Tipo de informação:",
    choices = list("Total" = 1, "Urna" = 2), 
    selected = 1),
   hr(),
   leafletOutput("map",width="100%",height="550px")
   ) #div
   )) #navbar/tabpanel
   ) #body
   ) #fluidPage