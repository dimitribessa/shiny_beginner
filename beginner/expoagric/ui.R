#versao 0.3
#18-out-2018 (16:23h)
#26-out-2018 (17:06h)
  ui <-  tags$html(
         tags$head(
         tags$title("Agribusiness Analytics"),
         tags$meta(charset="utf-8"),
         tags$link(rel = "stylesheet", type = "text/css", href = "style.css"), # href="bootstrap.min.css")
         tags$link( href="bootstrap.min.css", rel="stylesheet")
      ),  #head
     tags$body(         
  #abas para as diversas páginas   #
  navbarPage(tags$span(class = 'img-logo'),
  #tags$img(src = 'epagri_logo.png'),

  tabPanel('Exportações Agropecuária',
   tags$section( id = 'ferramenta',
   h1('Painel dinâmico'),
  
    fluidRow( 
    # Define the sidebar with one input
    column(5,
     selectInput('produto',"Produto:",
                  choices = c('Tudo',unique(export$Prod.SH4))),
                   helpText("Fonte: MDIC 2018")),
    column(2,   
      selectInput('pais',"País Destino:",
                  choices = c('Tudo', unique((export$NO_PAIS))), selected = 'Tudo')),
    column(2,offset = 3, 
    selectInput("municipio", "Municipio:", 
                  choices= c(unique(export$NOME)), selected="Florianópolis"))
                  ) #fluidRow
        ), #section
    hr(),      
     tags$div(class = 'container',
  leafletOutput("mapa",width="100%",height="450px"),
   hr(),
   fluidRow(
      column(6,checkboxInput("checkpais", label = h4("Volume"), value = FALSE),plotlyOutput('gplotII')),
      column(6,checkboxInput("checkproduto", label = h4("Volume"), value = FALSE),plotlyOutput('gplotIII'))),
   br(),
    fluidRow( column(4,h4("Quadro Resumo:"), tableOutput("view")),column(8,plotlyOutput('ggplotIV')))
   
   )#div
   ), #tabpanel expo
   #---------------------------------------------------------------------------#
   tabPanel('Produção Agronegócio',
    tags$div( class = 'wrapper',
     tags$nav( class = 'sidebar',
      tags$div( class = 'sidebar-header',
       h1('Painel dinâmico')
      ), #sidebar-header
      selectInput('ano',"Ano:",
                  choices = c(2010:2015), selected = 2015),
      selectInput('pib',"Indicador:",
                  choices = c('Agropecuária' = 'agropec', 'Agroindústria' = 'agroind',
                  'Agronegócio' = 'agroneg'), selected = 'Agropecuária'),
      checkboxInput("checkbox", label = "% do Município", value = FALSE)
     ),  #sidebar
     tags$div(class = 'content',
      leafletOutput("map",width="100%",height="450px")
     )#content
    ) #wrapper
  ), #tabpanel PIB
  #----------------------------------------------------------------------------#
  tabPanel('Redes insumos da cadeia agropecuária',
    tags$div( class = 'wrapper',
     tags$nav( class = 'sidebar',
      tags$div( class = 'sidebar-header',
       h1('Variáveis:')
      ), #sidebar-header
      selectInput('produtoii', 'Produto:',                               
       choices = unique(insumos$produto),
        selected = unique(insumos$produto)[1])
     ),  #sidebar
     tags$div(class = 'content',
      leafletOutput("rede",width="100%",height="450px")
     )#content
    ) #wrapper
  ) #tabPanel redes insumos
  ) #navbarpage    
  ) #body
  ) #html