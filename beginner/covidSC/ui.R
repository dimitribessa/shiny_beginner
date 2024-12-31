 #app corona vírus (16-mar-20, 16:00h)

 #modificado em 22-mar-20 (adicionando modelo epidemiológico)
 #modificado em 23-mar-20 (adicionado dados SES, 19:58h)
 #modificado em 14-abr-20 (adequando aos dados do Boa Vista)
 #modificado em 14-maio-20 (adicionando as análises regionais)
 #modificado em 23-jun-20 (modificado o título)
 #modificado em 13-jul-20 (médias móveis e casos ativos)
 #modificado em 15-out-20 (série de leitos)
 #modificado em 18-mar-21 (otimização de processos)
 
  ui <-  tags$html(
         tags$head(
         HTML('<script defer src="https://use.fontawesome.com/releases/v5.15.0/js/all.js"
          integrity="sha384-slN8GvtUJGnv6ca26v8EzVaR9DC58QEwsIk9q1QXdCU8Yu8ck/tL/5szYlBbqmS+"
           crossorigin="anonymous"></script>'),
         tags$meta(charset="utf-8"),
         tags$title("Dashboard COVID-19"),
         tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css"), # href="bootstrap.min.css")
         tags$link( href="bootstrap.min.css", rel="stylesheet"),
         HTML("<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src='https://www.googletagmanager.com/gtag/js?id=UA-157466259-2'></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-157466259-2');
</script>"),
  tags$style(type="text/css",
         ".shiny-output-error { visibility: hidden; }",
         ".shiny-output-error:before { visibility: hidden; }"
  )),
  
       #head
     tags$body(        
  #abas para as diversas páginas
  dashboardPage(skin = 'blue',
    dashboardHeader(
#	        tags$li(class = 'dropdown',style = "padding: 10px 1200px 0px 0px;", tags$p(class = 'myClass', 'Plataforma multiescalar territorial COVID-19'))
                ),
     dashboardSidebar(
      sidebarMenu(id = 'menu',
       menuItem("Casos", tabName = "caso", icon = icon("edit")),
      menuItem("Casos p/ Incidência", tabName = "incidencia", icon = icon("edit")),
     menuItem("Perfil Confirmados", tabName = "confirmados", icon = icon("briefcase-medical")),
      menuItem("Análise em Território", tabName = "regionalizada", icon = icon("map-marker-alt")),
      #  menuItem("Estatística global e nacional", icon = icon("chart-line"), tabName = "projecao"),
     menuItem("Taxas de transmissão (Rt)", icon = icon("project-diagram"), tabName = "rts",
     badgeColor = "green",
       badgeLabel = 'Novo!'),
    menuItem("Série leitos", tabName = "serie_leitos", icon = icon("clinic-medical"),
     badgeColor = "green",
       badgeLabel = 'Novo!'),
      
       br(),
       hr(),
      fluidRow(
      column(6, 
      tags$div(style = 'padding-left: 8px;',
      tags$img(src = './images/ses2020hbranco.png', width = '100%'
      ))),
     column(6,
      tags$div(
         tags$img(src = './images/defesa_civil.jpeg', width = '70%'
       ) ))), #endrow
       fluidRow(
      column(6,
       tags$div(style = 'padding-left: 8px;',
         tags$img(src = './images/COIIA_branco-03.png', width = '100%'
     ) )
     ),
     column(6,
      tags$div(
         tags$img(src = './images/coes.png', width = '80%', 
         style = 'display: block; text-align: center; padding-top: 10px;') ))), #endrow
         br(),
         br(),
      fluidRow(
      column(6,
       tags$div(style = 'padding-left: 8px;',
         p('Apoio:', style = 'color: white;'),
         tags$img(src = './images/fapesc_branco.png', width = '65%'
     ) )
     )) #endrow
      
     #  menuItem("Danos", icon = icon("fire"), tabName = "danos",
     # badgeColor = "orange",
     #  badgeLabel = 'Em desenvolvimento'),
       
       ) #sidebarMenu
      ),#sidebar
        
     dashboardBody(
       tags$script(HTML('
      $(document).ready(function() {
        $("header").find("nav").append(\'<div class="myClass"> Plataforma multiescalar territorial COVID-19 </div>\');
      })
     ')),
      tabItems(
           tabItem(tabName = 'caso',
           fluidRow(
            column(6,
     radioButtons('periodoanalise',label = '', choices = c('Todo período' = 1,'Últimos 7 dias' = 2,'Últimos 14 dias' = 3 ), selected = 1,
     inline = T)
     ),
           column(6, 
           uiOutput('caso_slider')
            )
     ), #endrow
      leafletOutput('mapa'),

       uiOutput('ui_inicial')
       
          ), #end tabitem caso

        tabItem(tabName = 'incidencia',
         
          fluidRow(
           column(6, offset = 6,
           uiOutput('incid_slider')
            )
     ), #endrow 
           
  tabsetPanel(type = "tabs", id = 'painel_inci',    
      tabPanel("País",leafletOutput('mapa_inci')
        ),
      tabPanel('SC',leafletOutput('mapa_incii')
    )),
    
    hr(),
   # verbatimTextOutput('teste'),
    fluidRow(
             
            column(6,
                   h4('Tx. Incidência por Estado*'), 
                   radioButtons('incid_estado',label = '', choices = c('Confirmados' = 1,'Óbitos' = 2), selected = 1,
     inline = T),
     barhighOutput2('rankbar'),
                   p('*por 100.000 habitantes')),
            column(6,
                   h4('Tx. Incidência por Município/SC*'),
                   radioButtons('incidmunicipio',label = '', choices = c('Confirmados' = 1,'Óbitos' = 2 ), selected = 1,
     inline = T),
    barhighOutput2('rankbarII'),
                   p('*por 100.000 habitantes'))       
                   ),#endrow
    fluidRow(
             
            column(6,
                  h4('Série das Incidências por Estado*'),
                  p('dias equalizados'),
                    uiOutput('incid_pickerestado'),
                   linehighOutput('linechartI'),
                   hr(),
                  h4('Série das Incidências por Estado*'),
                  p('por data'),
                  br(),
                    timehighOutput('timechartII'),
                   p('*por 100.000 habitantes')
                   ), #endcolumn
            column(6,
                  h4('Série das Incidências por Município*'),
                  p('dias equalizados'),
                   uiOutput('incid_pickermun'),
                   linehighOutput('linechartmunI'),
                   hr(),
                  h4('Série das Incidências por municipio*'),
                  p('por data'),
                  br(),
                    timehighOutput('timechartmunII'),
                   p('*por 100.000 habitantes')
                   )
                 
                   )#endrow
    
    
          ),
          
          tabItem(tabName = 'projecao',
          HTML('<iframe src = "https://cassianord.shinyapps.io/COVID-19_v0_01/", width = "100%",
                        height = "1200px"">
                </iframe>')
          ),  #end tabItem proj
   
      tabItem(tabName = 'confirmados',
           fluidRow(column(6,
     radioButtons('periodoanalise_vs',label = '', choices = c('Todo período' = 1,'Últimos 7 dias' = 2,'Últimos 14 dias' = 3 ), selected = 1,
     inline = T)),
           column(6,
           uiOutput('vs_slider')
            )
     ), #endrow

          leafletOutput('mapacasos', width = '100%') ,
         br(),
         fluidRow(
           uiOutput('vs_sliderII')
           
                  ), #endRow
    br(),
    fluidRow(
      column(6,
      h3('Pirâmide etária por sexo'),
      genderhighOutput('genderplot')),
      column(6,
               valueBoxOutput("soma_casos", width = NULL),
               p('*contabilizado somente casos com idade e sexos informados'),
               fluidRow(
                 column(6,
                   valueBoxOutput("prop_h", width = NULL)),
                 column(6,
                   valueBoxOutput("prop_f", width = NULL))
                   ),
               fluidRow(
                 column(12,
                   valueBoxOutput("media_idade", width = NULL))
                   ), #endrow
             #  fluidRow(
             #    column(12,
              #     valueBoxOutput("qtde_internados", width = NULL))
               #    ), #endrow
               fluidRow(
                 column(12,
                   valueBoxOutput("media_dias_exame", width = NULL))
                   ) #endrow
                   ) #endcolumn
      ),#endrow
    br(),

    fluidRow(
     column(12,
    h2('Sintomas'),
    p('Quantidade de ocorrências.'),
    barhighOutput('bar_sintomas')
     )
    )
        
        ),#end tabItem confirmados

 tabItem(tabName = 'regionalizada',
    fluidRow(column(6,
          radioButtons('periodoanalise_reg',label = '',
           choices = c('Todo período' = 1,'Últimos 7 dias' = 2,'Últimos 14 dias' = 3 ), selected = 1,
     inline = T)),
           column(6,
           uiOutput('regs_slider')
            )
     ), #endrow
     
         tabsetPanel(type = "tabs", id = 'painel_regs',
      tabPanel("Macrorregião",
      fluidRow(
       column(6,
          leafletOutput('mapa_macrorreg', width = '100%', height = '450px')) ,
       column(6,
          # pickerInput("macrorreg_map", "Macrorregiões Saúde:",
           #       choices= c(levels(dado_positivo$macrorregiao)), selected = levels(dado_positivo$macrorregiao),
            #      options = list(`actions-box` = TRUE, `none-selected-text` = "Selecionar"),
             #     multiple = T),
          radioButtons('graf_regional',label = '',
             choices = c('Confirmados' = 1,'Óbitos' = 2 ),
             selected = 1,
            inline = T) ,
          linehighOutput('lines_macrorreg')
          )
       ), #end Row

        
    fluidRow(
      column(5,
      h3('Ranking dos territórios'),
       barverthighOutput('ranking_reg')),
       column(7,
       h3('Análise multivariada'),
       p('Incidência (casos) / Letalidade / Qtd. Óbitos'),
          bubblehighOutput('macrobubble'))
      ), #endrow
   #adicionado em 21-set-2020 (15:29h)
   fluidRow(
      column(6,
           h3('Série casos ativos'),
     linehighOutput('graf_sc_ativo_macro'))
     ), #endrow
     br()
     
    ),#end tabpanel macro

     tabPanel("Regiões",
      fluidRow(
       column(6,
          leafletOutput('mapa_reg_saude', width = '100%', height = '450px')) ,
       column(6,
          # pickerInput("macrorreg_map", "Macrorregiões Saúde:",
           #       choices= c(levels(dado_positivo$macrorregiao)), selected = levels(dado_positivo$macrorregiao),
            #      options = list(`actions-box` = TRUE, `none-selected-text` = "Selecionar"),
             #     multiple = T),
          radioButtons('graf_regional_saude',label = '',
             choices = c('Confirmados' = 1,'Óbitos' = 2 ),
             selected = 1,
            inline = T) ,
          pickerInput("list_regionais", "",
                  choices= c(levels(tab_regioes$reg_saude)), selected = c(levels(tab_regioes$reg_saude)),
                  options = list(`actions-box` = TRUE, `none-selected-text` = "Selecionar"),
                  multiple = T),
          linehighOutput('lines_regionais')
          )
       ), #end Row

        
    fluidRow(
      column(5,
      h3('Ranking dos territórios'),
       barverthighOutput('ranking_regionais')),
       column(7,
       h3('Análise multivariada'),
       p('Incidência (casos) / Letalidade / Qtd. Óbitos'),
          bubblehighOutput('macrobubble_regionais'))
      ), #endrow
      br(),
      #adicionado em 21-set-2020 (15:29h)
   fluidRow(
      column(6,
           h3('Série casos ativos'),
     linehighOutput('graf_sc_ativo_reg'))
     ), #endrow
     br()

      )#end regionais saude 
    )#end tabpanel regionais

    

        ),#end tabItem regionalizada
        
   tabItem(tabName = 'rts',
          HTML('<iframe src = "https://cassianord.shinyapps.io/numero_reproducao_novo/", width = "100%",
                        height = "1200px"">
                </iframe>')
          ),  #end tabItem rts   
  
      
   tabItem(tabName = 'serie_leitos',
    fluidRow(
    column(8,
     dateInput('data_serie',
      label = 'Dia:', min = min(names(serie_ocup)), max = max(names(serie_ocup)),
      value = max(names(serie_ocup))),
    tabsetPanel(type = "tabs", id = 'painel_regs_series',
     tabPanel("Macrorregião",
          leafletOutput('mapaleitos_serie_macro', width = '100%') ,
         br()
     
                  ), #endpanel macrorregião

     tabPanel("Região",
          leafletOutput('mapaleitos_serie_reg', width = '100%') ,
         br()

                  )#, #endpanel região
    # tabPanel("Município",
     #     leafletOutput('mapaleitos_serie_munic', width = '100%') ,
      #   br()

                  #), #endpanel município
        # br()
                  
    ) #endTabsetpanel
     ), #endcolumn
    column(4,
      h4('UTI - % de ocupação'),
     
        barverthighOutput('cont_chart_serie', height = '420px')
    )
    ), #endrow
    fluidRow(
      column(2,
       checkboxInput('iscovid_leito', 'Somente leitos UTI COVID', value = TRUE)
       )),
    fluidRow(
      
      column(12,
      h4('UTI - Série da ocupação (%)'),
       linerangeOutput('lines_serie', height = '420px')
       #linehighOutput('lines_serie')
          ) #endcolumn  
        ), #endrow
          
          br(),
          
    fluidRow(
     column(6,
       h4('Série ocupação e totais (UTI)'),
       selectInput("list_serie", "Localidade:",
                  choices= c(levels(dado_hist_mov$macrorregiao.atendimento)), 
                  selected =  c(levels(dado_hist_mov$macrorregiao.atendimento)[1]),
                  multiple = F),
        linerangeOutput('lines_ocup_serie')),
         column(6,
      h4('Tempo médio de ocupação UTI'),
        dateRangeInput('dateRange_serie',
      label = 'Datas',
      min = min(names(serie_ocup)), max = max(names(serie_ocup)),
      start =  min(names(serie_ocup)), end = max(names(serie_ocup))
    ),
        barverthighOutput('chart_tempo_serie'))
        )    #endrow
   
   
     
    ) #end tabitem serie_leitos
                                 
          
          )#end tabItems
          ) #dashboardbody
       ) #dashboardPage
   
  )#body
  ) #html
                        