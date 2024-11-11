  ui <-  tags$html(
         tags$head(
         tags$meta(charset="UTF-8"),
         tags$title("Violência contra Mulher"),
         tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css"), # href="bootstrap.min.css")
         tags$link( href="bootstrap.min.css", rel="stylesheet")
      ),  #head
     tags$body(         
  #abas para as diversas páginas   #
  navbarPage('',
  tabPanel('Mulheres Agredidas',
            br(),
    fluidRow( 
    # Define the sidebar with one input
    column(2,
     tags$div( class = 'ferramenta',
     h1('Filtros'),
     br(),
     h3('Características:'),
     selectInput('idade',"Faixa de Idade:",
                  choices = c('Tudo',levels(all_data$IDADE)), selected = 'Tudo'),
                   
     selectInput('esc',"Escolaridade:",
                  choices = c('Tudo', levels(all_data$ESC)), selected = 'Tudo'),
                  
     selectInput('renda',"Renda:",
                  choices = c('Tudo', levels(all_data$RENDA)), selected = 'Tudo'),
     selectInput('cor',"Cor da pele:",
                  choices = c('Tudo', levels(all_data$RACACOR)), selected = 'Tudo'),
     hr(),
     h3('Motivação e tipo de agressão:'),
     selectInput('motivo',"Motivação:",
                  choices = c('Tudo', names(all_data)[11:21]), selected = 'Tudo'),
     selectInput('agressao',"Agressão:",
                  choices = c('Tudo', names(all_data)[22:28]), selected = 'Tudo')
                  ) #tag
                  ), #column1
     column(10,
      fluidRow(
         column(3,
          h2('Faixa de idade:'),
          barChartOutput('grafidade',  height="375px")),
         column(3,
          h2('Escolaridade:'),
          barChartOutput('grafescola',  height="375px")),
         column(3,
          h2('Faixa de renda:'),
          barChartOutput('grafrenda',  height="375px")),
         column(3,
          h2('Cor da Pele:'),
          barChartOutput('grafcor',  height="375px"))
                ),#fluidRow
      fluidRow(
       column(6,
          h2('Motivos para agressão:'),
        barChartOutput('grafmot')),
       column(6,
          h2('Tipo de agressão sofrida:'),
        barChartOutput('graftipo'))
                ) #fluidRow           
            ) #column11
        )#fluidRow
  ), #tabPanel agressao
  #-----------Painel dos dados de percepção --------------# (19-nov-18, 08:53h)
  tabPanel('Percepção sobre a violência doméstica',
            br(),
    fluidRow( 
    # Define the sidebar with one input
    column(2,
     tags$div( class = 'ferramenta',
     h1('Filtros'),
     br(),
     selectInput('ano',"Ano:",
                  choices = c(2011,2013,2015), selected = 'Tudo'),
      radioButtons("radio", 'Eixo X:',
    choices = list("Já sofreu agressão?" = 'violentada', "A mulher é tratada com respeito no país?" = 'tratamento'),
    selected = 'violentada'),
    hr(),
     h3('Características:'),
     selectInput('idade_p',"Faixa de Idade:",
                  choices = c('Tudo',levels(all_data$IDADE)), selected = 'Tudo'),
                   
     selectInput('esc_p',"Escolaridade:",
                  choices = c('Tudo', levels(all_data$ESC)), selected = 'Tudo'),
                  
     selectInput('renda_p',"Renda:",
                  choices = c('Tudo', levels(all_data$RENDA)), selected = 'Tudo'),
     selectInput('cor_p',"Cor da pele:",
                  choices = c('Tudo', levels(all_data$RACACOR)), selected = 'Tudo')
                  ) #tag
                  ), #column1
     column(10,
      fluidRow(
         column(6,
          h3('A mulher é tratada com respeito no país?'),
          discreteChartOutput('tratamento',  height="375px")),
         column(6,
          h3('Onde a mulher é menos respeitada?'),
          discreteChartOutput('lugar',  height="375px"))
          ),
     fluidRow(
         column(6,
          h3('Nos últimos anos, a violência contra mulher...'),
          discreteChartOutput('opiniao_violencia',  height="375px")),
         column(6,
          h3('As mulheres denunciam a violência doméstica?'),
          discreteChartOutput('denuncia',  height="375px"))
          ),
     fluidRow(
         column(6,
          h3('As leis protegem contra a mulher contra a violência doméstica e familiar?'),
          discreteChartOutput('opiniao_lei',  height="375px")),
         column(6,
          h3('O que leva a mulher não denunciar a agressão?'),
          discreteChartOutput('nao_denuncia',  height="375px"))
          )
           ) #column11
        )#fluidRow
  ) #tabPanel percepção
  ) #navbarpage    
  ) #body
  ) #html

