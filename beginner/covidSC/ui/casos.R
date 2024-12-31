 #ui casos
 list(
 fluidRow(
            column(6,
     radioButtons('periodoanalise',label = '', choices = c('Todo período' = 1,'Últimos 7 dias' = 2,'Últimos 14 dias' = 3 ), selected = 1,
     inline = T)
     ),
           column(6, 
           sliderInput("range", label = h3("Dia"),as.Date('2020-03-12'),
     max(data_ufs[data_ufs[,'Codigos'] == 42,1]),
      value = max(data_ufs[data_ufs[,'Codigos'] == 42,1]), step = 1, 
                  animate = FALSE)
            )
     ), #endrow
     verbatimTextOutput('texto'),
      leafletOutput('mapa'),

      tags$div(class = 'ferramenta',

  fluidRow(
    
     column(6,
       uiOutput('qtde_municipios')),
     column(6,
       uiOutput('novos_casos'))
       )#enddiv
         ),
    hr(),
   #verbatimTextOutput('teste')  ,
     fluidRow(
     column(4,
           h5('Casos diários'),
            radioButtons('buttondiario',label = '', choices = c('Confirmados' = 1,'Óbitos' = 2), selected = 1,
     inline = T),
     barhightime2Output('graf_sc_diario')),
     column(4,
           h5('Novos casos'),
     actionLink('nota2', 'Nota explicativa'),
           radioButtons('buttonnovos',label = '', choices = c('Confirmados' = 1,'Óbitos' = 2), selected = 1,
     inline = T),
           barhightime2Output('graf_sc_diario_novos')),
     column(4,
         valueBoxOutput("obitos", width = NULL),
         valueBoxOutput("qtde_confirmado", width = NULL),
         valueBoxOutput("qtde_recuperados", width = NULL))
            ),#endrow, 
            br(),
        fluidRow(
          column(4,
          tags$div(class = 'scrollery',
          h5('Casos por município'),
          radioButtons('buttonmunicipio',label = '', choices = c('Confirmados' = 1,'Óbitos' = 2), selected = 1,
     inline = T),
           barverthighOutput('municipio_chart', height = '400px'))
           ),
           column(4,
           valueBoxOutput("media_dia_exame", width = NULL),
           #valueBoxOutput("media_dia_morte", width = NULL),
           valueBoxOutput("tx_positivo", width = NULL)
            ),
            column(4,
             h5('Quantidade de municípios afetados'),
             barhightimeOutput('serie_media_exame')
             )
          ),#endRow
  
   #adicionado em 15-jul-2020
   fluidRow(
     column(4,
           h5('Casos p/semana epidemiológica'),
           radioButtons('buttonsemanal',label = '', choices = c('Confirmados' = 1,'Óbitos' = 2), selected = 1,
     inline = T),
     barhightime2Output('graf_sc_semana')),
     
     column(4,
           h5('Série casos ativos'),
     barhightime2Output('graf_sc_ativo'),
     actionLink('nota', 'Nota explicativa'))
     ), #endrow
     br()
       
 )