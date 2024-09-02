#-----------------------------------------------------------------------------#
#---------------shiny V8 (08-mar-2019, 01:06h)--------------------------------#
#-----------------------------------------------------------------------------#
#!atualizado em 14-mar-2019 (13:27h)

ui <-  tags$html(
         tags$head(
         tags$meta(charset="utf-8"),
         tags$title("Proposta V8"),
         tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css"), # href="bootstrap.min.css")
         tags$link( href="bootstrap.min.css", rel="stylesheet")
      ),  #head
     tags$body(
  #abas para as diversas páginas
  navbarPage("Página em desenvolvimento",
  tabPanel('Georreferenciamento Estabelecimentos',
    tags$div(id = 'mapa',
           # If not using custom CSS, set height of leafletOutput to a number instead of percent
      leafletOutput("mapi", width="100%", height="100%"),

      # Shiny versions prior to 0.11 should use class = "modal" instead.
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto",

        h2("Estabelecimentos"),
        selectInput("cnae", "CNAE:", c(25803)),
        br(),
        h3('Distribuição das firmas por qtde. de funcionários:'),
        barC3Output("grafqtde", height = '300px')
        #verbatimTextOutput('texto')
        )#absolute panel
    )#div mapa
    ), #tabPanel
  
  
  tabPanel('Tendência ICMS',
  tags$div(id = 'tendencia', class = 'container',
   fluidRow(
     column(6,
            h3('Recolhimento mensal do ICMS em Santa Catarina, agrupados por CNAE.'),
            timeC3Output('icms'),
            p('Obs. Valores deflacionados pelo INPC, com base no último período analisado.')), #column
     column(6,
            h3('Sazonalidades do ICMS em Santa Catarina, agrupados por CNAE.'),
            lineC3Output('sazonalidade')
            ) #column
            )#fluidRow
               ),#tagdiv
                   br()
          ), #tabPanel
          
     tabPanel('Detalhes da proposta.',
  tags$div(id = 'proposta', class = 'container',
   tags$div(class = 'ferramenta',
    h1('Objetivo:'),
    h3('Levantar informações para prospecção de mercado, com intuito de identificar potenciais clientes da V8 Brasil.'),
    p('As ferramentas disponibilizadas são protótipos, que serão ajustados de acordo com as necessidades da V8 Brasil.')
    ),#ferramenta
    hr(),
   fluidRow(
     column(6,
           tags$div(class = 'ferramenta',
           tags$div(class = 'imagem',
            img( src = 'imagens/geotracking.png', width = '65%')),
            br(),
            h3('Georreferenciamento das empresas.'),
            p('Permite identificar onde estão as firmas e o seu tamanho, usando com referência o CEP e a quantidade de funcionários empregados, respectivamente.'),
            p('O intuito da ferramente é captar potenciais clientes dos produtos da V8 Brasil.'))
            ), #column
     column(6,
          tags$div(class = 'ferramenta',
          tags$div(class = 'imagem',
            img( src = 'imagens/trend3.png', width = '70%')),
            br(),
            h3('Tendências de arrecadação do ICMS.'),
            p('A arrecadação do ICMS é um reflexo das atividades produtiva das firmas.'),
            p('Estimar sua tendência permite duas análises: i. olhando a série histórica, conhecer a reação das vendas dos produtos V8 perante a a expansão/retração dos outros setores produtivos, e ii. traçar uma estratégia de vendas ao observar as tendências e sazonalidades destas atividades econômicas.'))
            )#column
            )#fluidRow
               ),#tagdiv
                   br()
          ) #tabPanel
   )#navbarPage
  )#body
  ) #html
