 #editado para o shiny do covidSC (07-jun-2021, 12:22h)


 list(fluidPage(
    
    # Application title
    titlePanel("COVID-19 - Estatísticas Nacionais e Internacionais"),
    
    #abas para as diversas páginas
    navbarPage( '', id = "selected_menu",
                
                ## . Menus para Países ----
                navbarMenu("Países",
                           
                           # ... Menu 1, Aba 1 ----
                           tabPanel('Casos e cenários',
                                    
                                    sidebarLayout(
                                        sidebarPanel(
                                            h4(HTML(paste0("<b>", "Casos confirmados:", "</b>"))), 
                                            h5(HTML(paste0("<b>", "No mundo:", "</b>"))), 
                                            htmlOutput("total_mundo1"),
                                            htmlOutput("total_mundo1_lastday"),
                                            h5(HTML(paste0("<b>", "No Brasil:", "</b>"))),
                                            htmlOutput("total_br1"),
                                            htmlOutput("total_br1_lastday"),
                                            hr(),
                                            selectInput("country", "Selecione os países:", paises_lista_100, 
                                                        selected = c("Brazil", "United States", "Spain", "Italy", "Japan", "United Kingdom",
                                                                     "Chile", "France", "Germany", "South Korea", "Iran", "Poland"),
                                                        multiple = TRUE),
                                            selectInput("highlight", "Selecione um país para destacar:", paises_lista_100, 
                                                        selected = c("Brazil"),
                                                        multiple = FALSE),
                                            radioButtons("eixoy1", "Escolha a variável do eixo vertical", 
                                                         choices = c("Casos", "Casos por 100 mil habitantes"), selected = "Casos"),
                                            radioButtons("escala1", "Escolha a escala do gráfico", 
                                                         choices = c("Logarítmica", "Linear"), selected = "Logarítmica"),
                                            img(src = "legenda_cenarios.png", height = 125, width = 196),
                                            h5("Notas:"), 
                                            h6("1: As estimativas da projeção geral levam em consideração todos os países, exceto os dos cenários abaixo."),
                                            h6("2: As estimativas do cenário pessimista se baseiam em países com maior intensidade dos casos."),
                                            h6("3: As estimativas do cenário otimista se baseiam em países com menor intensidade dos casos."),
                                            h5("Fonte dos dados:"),
                                            h6("Johns Hopkins University, Center for Systems Science and Engineering (CSSE)."),
                                            width = 2
                                        ), # end sidebar
                                        mainPanel(
                                            plotlyOutput(outputId = 'serie1', height = 800),
                                            width = 10
                                        ) #end main panel
                                    ),
                           ), # end tab
                           
                           
                           # ... Menu 1, Aba 2 ----
                           tabPanel('Novos casos/óbitos diários e fatores de crescimento',
                                    sidebarLayout(
                                        sidebarPanel(
                                            selectInput("country3", "Selecione o país:", paises_lista_50, 
                                                        selected = c("Brazil"),
                                                        multiple = FALSE),
                                            radioButtons("var4", "Escolha a variável", 
                                                         choices = c("Casos confirmados", "Mortes"), selected = "Casos confirmados"),
                                            h5("Notas:"), 
                                            h6(paste0("1: O Fator de Crescimento equivale à proporção de novos casos/óbitos em um dia em relação",
                                                      " aos novos casos/óbitos do dia anterior. Um Fator acima de 1 indica crescimento dos novos casos/óbitos,",
                                                      " ao passo que um Fator entre 0 e 1 indica decréscimo. Fatores consistentemente acima de 1",
                                                      " indicam a possibilidade de um crescimento exponencial.")),
                                            h5("Fontes dos dados:"),
                                            h6("Johns Hopkins University, Center for Systems Science and Engineering (CSSE)."),
                                            width = 2
                                        ), # end sidebar
                                        mainPanel(
                                            plotlyOutput(outputId = 'serie3_1', height = 400),
                                            plotlyOutput(outputId = 'serie3_2', height = 400),
                                            width = 10
                                        ) #end main panel
                                    ),
                           ), # end tab
                           
                           
                           # .... Menu 1, Aba 3 ----
                           tabPanel('Taxa de letalidade',
                                    
                                    sidebarLayout(
                                        sidebarPanel(
                                            h4(HTML(paste0("<b>", "Taxa de letalidade:", "</b>"))), 
                                            h5(HTML(paste0("<b>", "No mundo:", "</b>"))), 
                                            htmlOutput("cfr_mundo"),
                                            h5(HTML(paste0("<b>", "No Brasil:", "</b>"))),
                                            htmlOutput("cfr_brasil"),
                                            hr(),
                                            selectInput("country4", "Selecione os países:", c(paises_lista, "World"),
                                                        selected = c("Brazil", "World", "United States", "Spain", "Italy", "Japan", 
                                                                     "South Korea"),
                                                        multiple = TRUE),
                                            selectInput("highlight4", "Selecione um país para destacar:", paises_lista, 
                                                        selected = c("Brazil"),
                                                        multiple = FALSE),
                                            radioButtons("eixo4", "Escolha o eixo horizontal", 
                                                         choices = c("Data", "Dias desde o primeiro caso"), selected = "Data"),
                                            h5("Notas:"), 
                                            h6(paste0("1: A Taxa de Letalidade (ou Case Fatality Rate, CFR, em inglês), consiste na proporção de mortes",
                                                      " em relação ao total de casos diagnosticados durante certo momento no tempo. A Taxa de Letalidade",
                                                      " só pode ser considerada final ou definitiva quando todos os casos foram concluídos (com morte ou",
                                                      " recuperação). Geralmente a taxa preliminar ao longo de um surto epidêmico com rápido aumento de",
                                                      " casos diagnosticados e com resolução relativamente lenta tende a ser menor que a taxa final.")),
                                            h5("Fontes dos dados:"),
                                            h6("Johns Hopkins University, Center for Systems Science and Engineering (CSSE)."),
                                            width = 2
                                        ), # end sidebar
                                        mainPanel(
                                            plotlyOutput(outputId = 'serie4', height = 800),
                                            width = 10
                                        ) #end main panel
                                    ),
                           ), # end tab
                           
                           
                           # ... Menu 1, Aba 4 ----
                           tabPanel('Mortes',
                                    
                                    sidebarLayout(
                                        sidebarPanel(
                                            h4(HTML(paste0("<b>", "Total de mortes:", "</b>"))), 
                                            h5(HTML(paste0("<b>", "No mundo:", "</b>"))), 
                                            htmlOutput("total_mortes_mundo"),
                                            htmlOutput("total_mortes_mundo_lastday"),
                                            h5(HTML(paste0("<b>", "No Brasil:", "</b>"))),
                                            htmlOutput("total_mortes_br"),
                                            htmlOutput("total_mortes_br_lastday"),
                                            hr(),
                                            selectInput("country5", "Selecione os países:", paises_lista,
                                                        selected = c("Brazil", "United States", "Spain", "Italy", "Japan", 
                                                                     "South Korea", "Germany", "United Kingdom"),
                                                        multiple = TRUE),
                                            selectInput("highlight5", "Selecione um país para destacar:", paises_lista, 
                                                        selected = c("Brazil"),
                                                        multiple = FALSE),
                                            radioButtons("var_mortes_paises", "Escolha a variável", 
                                                         choices = c("Mortes", "Mortes por 100 mil habitantes"), selected = "Mortes"),
                                            radioButtons("escala_mortes", "Escolha a escala do gráfico", 
                                                         choices = c("Logarítmica", "Linear"), selected = "Logarítmica"),
                                            
                                            # Mostrar painel se var_mortes_paises = Mortes
                                            conditionalPanel(
                                                condition = "input.var_mortes_paises == 'Mortes'",
                                                
                                                radioButtons("eixo_mortes", "Escolha o eixo horizontal", 
                                                             choices = c("Data", "Dias desde o primeiro caso"), selected = "Dias desde o primeiro caso")
                                                
                                            ), # end conditional panel
                                            
                                            # Mostrar painel alternativo se var_mortes_paises = Mortes por 100 mil habitantes
                                            conditionalPanel(
                                                condition = "input.var_mortes_paises == 'Mortes por 100 mil habitantes'",
                                                
                                                radioButtons("eixo_mortes_alt", "Escolha o eixo horizontal", 
                                                             choices = c("Data", "Dias desde 0,1 mortes por 100 mil hab."), 
                                                             selected = "Dias desde 0,1 mortes por 100 mil hab.")
                                                
                                            ), # end conditional panel 2
                                            
                                            h5("Fontes dos dados:"),
                                            h6("Johns Hopkins University, Center for Systems Science and Engineering (CSSE)."),
                                            width = 2
                                        ), # end sidebar
                                        mainPanel(
                                            plotlyOutput(outputId = 'serie_mortes', height = 800),
                                            width = 10
                                        ) #end main panel
                                    ),
                           ) # end tab
                           
                           
                ), # End Menu dos Países
                
                
                # . Menus para Estados ----
                navbarMenu("Estados do Brasil",
                           
                           # ... Menu 2, Aba 1 ----
                           tabPanel('Casos',
                                    
                                    sidebarLayout(
                                        sidebarPanel(
                                            h4(HTML(paste0("<b>", "Casos Confirmados:", "</b>"))), 
                                            h5(HTML(paste0("<b>", "No Brasil:", "</b>"))), 
                                            htmlOutput("total_casos_br"),
                                            h5(htmlOutput("UF_casos_total")),
                                            htmlOutput("total_casos_uf"),
                                            hr(),
                                            selectInput("ufs1", "Selecione os estados:", ufs_lista, 
                                                        selected = c("São Paulo", "Santa Catarina", "Rio de Janeiro", "Distrito Federal", "Minas Gerais",
                                                                     "Pernambuco", "Paraná", "Rio Grande do Sul", "Bahia"),
                                                        multiple = TRUE),
                                            selectInput("highlight_uf", "Selecione um Estado para destacar:", ufs_lista, 
                                                        selected = c("Santa Catarina"),
                                                        multiple = FALSE),
                                            radioButtons("escala_casos21", "Escolha a variável do eixo vertical", 
                                                         choices = c("Casos", "Casos por 100 mil habitantes"), 
                                                         selected = "Casos"),
                                            radioButtons("escala5", "Escolha a escala do gráfico", 
                                                         choices = c("Logarítmica", "Linear"), selected = "Logarítmica"),
                                            
                                            
                                            # Mostrar painel se escala_casos21 = Casos
                                            conditionalPanel(
                                                condition = "input.escala_casos21 == 'Casos'",
                                                
                                                radioButtons("eixo5", "Escolha o eixo horizontal", 
                                                             choices = c("Data", "Dias desde o primeiro caso"), 
                                                             selected = "Dias desde o primeiro caso"),
                                                
                                            ), # end conditional panel
                                            
                                            # Mostrar painel alternativo se escala_casos21 = Casos por 100 mil habitantes
                                            conditionalPanel(
                                                condition = "input.escala_casos21 == 'Casos por 100 mil habitantes'",
                                                
                                                radioButtons("eixo5_alt", "Escolha o eixo horizontal", 
                                                             choices = c("Data", "Dias desde 0,1 casos por 100 mil hab."), 
                                                             selected = "Dias desde 0,1 casos por 100 mil hab."),
                                                
                                            ), # end conditional panel 2
                                            
                                            
                                            h5("Fonte dos dados:"),
                                            h6(HTML(paste0("<a href=\"https://brasil.io/home/\" target=\"_blank\">", "Brasil.io", "</a>"))),
                                            width = 2
                                        ), # end sidebar
                                        mainPanel(
                                            plotlyOutput(outputId = 'serie5', height = 800),
                                            width = 10
                                        ) #end main panel
                                    ),
                           ), # end tab
                           
                           
                           # ... Menu 2, Aba 2 ----
                           tabPanel('Proporção do total e fatores de crescimento (todas UFs)',
                                    
                                    sidebarLayout(
                                        sidebarPanel(
                                            selectInput("ufs2", "Selecione os estados:", ufs_lista, 
                                                        selected = c("São Paulo", "Santa Catarina", "Rio de Janeiro", 
                                                                     "Distrito Federal", "Ceará"),
                                                        multiple = TRUE),
                                            selectInput("highlight_uf2", "Selecione um Estado para destacar:", ufs_lista, 
                                                        selected = c("Santa Catarina"),
                                                        multiple = FALSE),
                                            selectInput("tipo_uf", "Escolha o gráfico a visualizar:", 
                                                        choices = c("Fator de crescimento", "Participação no total de casos"),
                                                        selected = "Participação no total de casos"),
                                            h5("Notas:"), 
                                            h6(paste0("1: O Fator de Crescimento equivale à proporção de novos casos em um dia em relação",
                                                      " aos novos casos do dia anterior. Um Fator acima de 1 indica crescimento dos novos casos,",
                                                      " ao passo que um Fator entre 0 e 1 indica decréscimo. Fatores consistentemente acima de 1",
                                                      " indicam a possibilidade de um crescimento exponencial.")),
                                            h5("Fonte dos dados:"),
                                            h6(HTML(paste0("<a href=\"https://brasil.io/home/\" target=\"_blank\">", "Brasil.io", "</a>"))),
                                            width = 2
                                        ), # end sidebar
                                        mainPanel(
                                            plotlyOutput(outputId = 'serie6', height = 800),
                                            width = 10
                                        ) #end main panel
                                    ),
                           ), # end tab
                           
                           
                           # ... Menu 2, Aba 3 ----
                           tabPanel('Taxa de letalidade',
                                    
                                    sidebarLayout(
                                        sidebarPanel(
                                            h4(HTML(paste0("<b>", "Taxa de Letalidade:", "</b>"))), 
                                            h5(HTML(paste0("<b>", "No Brasil:", "</b>"))), 
                                            htmlOutput("cfr_br"),
                                            h5(htmlOutput("UF_cfr")),
                                            htmlOutput("cfr_uf"),
                                            hr(),
                                            selectInput("ufs4", "Selecione os estados:", c(ufs_lista, "Brasil"),
                                                        selected = c("Santa Catarina", "São Paulo", "Rio de Janeiro", "Brasil", 
                                                                     "Amazonas", "Ceará"),
                                                        multiple = TRUE),
                                            selectInput("highlight_uf4", "Selecione um Estado para destacar:", ufs_lista, 
                                                        selected = c("Santa Catarina"),
                                                        multiple = FALSE),
                                            radioButtons("eixo_cfr_ufs", "Escolha o eixo horizontal", 
                                                         choices = c("Data", "Dias desde o primeiro caso"), selected = "Data"),
                                            h5("Notas:"), 
                                            h6(paste0("1: A Taxa de Letalidade (ou Case Fatality Rate, CFR, em inglês), consiste na proporção de mortes",
                                                      " em relação ao total de casos diagnosticados durante certo momento no tempo. A Taxa de Letalidade",
                                                      " só pode ser considerada final ou definitiva quando todos os casos foram concluídos (com morte ou",
                                                      " recuperação). Geralmente a taxa preliminar ao longo de um surto epidêmico com rápido aumento de",
                                                      " casos diagnosticados e com resolução relativamente lenta tende a ser menor que a taxa final.")),
                                            h5("Fonte dos dados:"),
                                            h6(HTML(paste0("<a href=\"https://brasil.io/home/\" target=\"_blank\">", "Brasil.io", "</a>"))),
                                            width = 2
                                        ), # end sidebar
                                        mainPanel(
                                            plotlyOutput(outputId = 'serie_cfr_ufs', height = 800),
                                            width = 10
                                        ) #end main panel
                                    ),
                           ), # end tab
                           
                           
                           # ... Menu 2, Aba 4 ----
                           tabPanel('Mortes',
                                    
                                    sidebarLayout(
                                        sidebarPanel(
                                            h4(HTML(paste0("<b>", "Total de Mortes:", "</b>"))), 
                                            h5(HTML(paste0("<b>", "No Brasil:", "</b>"))), 
                                            htmlOutput("total_deaths_br"),
                                            h5(htmlOutput("UF_deaths_total")),
                                            htmlOutput("total_deaths_uf"),
                                            hr(),
                                            selectInput("ufs5", "Selecione os estados:", ufs_lista,
                                                        selected = c("Santa Catarina", "São Paulo", "Rio de Janeiro", "Amazonas",
                                                                     "Ceará", "Distrito Federal", "Rio Grande do Sul"),
                                                        multiple = TRUE),
                                            selectInput("highlight_uf5", "Selecione um Estado para destacar:", ufs_lista, 
                                                        selected = c("Santa Catarina"),
                                                        multiple = FALSE),
                                            radioButtons("var_morte", "Escolha a variável", 
                                                         choices = c("Mortes", "Mortes por 100 mil habitantes"), selected = "Mortes"),
                                            #conditionalPanel(
                                            #   condition="input.var_morte == 'Mortes'",
                                            radioButtons("escala_mortes_ufs", "Escolha a escala do gráfico", 
                                                         choices = c("Logarítmica", "Linear"), selected = "Logarítmica"),
                                            #),
                                            
                                            # Mostrar painel se var_morte = Mortes
                                            conditionalPanel(
                                                condition = "input.var_morte == 'Mortes'",
                                                
                                                radioButtons("eixo_mortes_ufs", "Escolha o eixo horizontal", 
                                                             choices = c("Data", "Dias desde a primeira morte"), 
                                                             selected = "Dias desde a primeira morte"),
                                                
                                            ), # end conditional panel
                                            
                                            # Mostrar painel alternativo se var_morte  = Mortes por 100 mil habitantes
                                            conditionalPanel(
                                                condition = "input.var_morte == 'Mortes por 100 mil habitantes'",
                                                
                                                radioButtons("eixo_mortes_ufs_alt", "Escolha o eixo horizontal", 
                                                             choices = c("Data", "Dias desde 0,1 mortes por 100 mil hab."), 
                                                             selected = "Dias desde 0,1 mortes por 100 mil hab."),
                                                
                                            ), # end conditional panel 2
                                            
                                            
                                            
                                            h5("Fonte dos dados:"),
                                            h6(HTML(paste0("<a href=\"https://brasil.io/home/\" target=\"_blank\">", "Brasil.io", "</a>"))),,
                                            width = 2
                                        ), # end sidebar
                                        mainPanel(
                                            plotlyOutput(outputId = 'serie_mortes_ufs', height = 800),
                                            width = 10
                                        ) #end main panel
                                    ),
                           ), # end tab
                           
                           
                           # ... Menu 2, Aba 5 ----
                           tabPanel('Novos casos/óbitos diários e fatores de crescimento (por UF)',
                                    sidebarLayout(
                                        sidebarPanel(
                                            selectInput("ufs6", "Selecione um Estado:", ufs_lista, 
                                                        selected = c("Santa Catarina"),
                                                        multiple = FALSE),
                                            radioButtons("var_uf6", "Escolha a variável", 
                                                         choices = c("Casos confirmados", "Mortes"), selected = "Casos confirmados"),
                                            h5("Notas:"), 
                                            h6(paste0("1: O Fator de Crescimento equivale à proporção de novos casos/óbitos em um dia em relação",
                                                      " aos novos casos/óbitos do dia anterior. Um Fator acima de 1 indica crescimento dos novos casos/óbitos,",
                                                      " ao passo que um Fator entre 0 e 1 indica decréscimo. Fatores consistentemente acima de 1",
                                                      " indicam a possibilidade de um crescimento exponencial.")),
                                            h5("Fonte dos dados:"),
                                            h6(HTML(paste0("<a href=\"https://brasil.io/home/\" target=\"_blank\">", "Brasil.io", "</a>"))),
                                            width = 2
                                        ), # end sidebar
                                        mainPanel(
                                            plotlyOutput(outputId = 'serie_uf6_1', height = 400),
                                            plotlyOutput(outputId = 'serie_uf6_2', height = 400),
                                            width = 10
                                        ) #end main panel
                                    ),
                           ), # end tab
                           
                           # ... Menu 2, Aba 6 ----
                           tabPanel('Tempo para duplicação de casos e mortes',
                                    sidebarLayout(
                                        sidebarPanel(
                                            selectInput("ufs7", "Selecione um Estado:", ufs_lista, 
                                                        selected = c("Santa Catarina"),
                                                        multiple = FALSE),
                                            h5("Notas:"), 
                                            h6(paste0("1: As barras verticais indicam quando houve duplicação das ocorrências",
                                                      " (casos confirmados ou mortes) em comparação com o valor da última duplicação.",
                                                      " Barras mais distantes entre si indicam menor velocidade no aumento das ocorrências,",
                                                      " ao passo que barras mais próximas significam que as ocorrências estão aumentando em ritmo mais acelerado.")),
                                            h5("Fonte dos dados:"),
                                            h6(HTML(paste0("<a href=\"https://brasil.io/home/\" target=\"_blank\">", "Brasil.io", "</a>"))),
                                            width = 2
                                        ), # end sidebar
                                        mainPanel(
                                            plotlyOutput(outputId = 'serie_uf7_1', height = 600),
                                            plotlyOutput(outputId = 'serie_uf7_2', height = 600),
                                            width = 10
                                        ) #end main panel
                                    ),
                           ) # end tab
                           
                ), # end Menu UFs
                
                
                
                # . Menu para Municípios ----
                navbarMenu("Municípios do Brasil",
                           
                           # ... Menu 3, Aba 1 ----
                           tabPanel("Mapas de casos e mortes nos municípios",
                                    sidebarLayout(
                                        sidebarPanel(
                                            selectInput("mun_var1", "Selecione uma variável:", c("Casos confirmados", "Mortes"), 
                                                        selected = c("Casos confirmados"),
                                                        multiple = FALSE),
                                            radioButtons("escala_mun1", "Selecione a escala da variável", 
                                                         choices = c("Valor absoluto", "Valor por 100 mil habitantes"), 
                                                         selected = "Valor absoluto"),
                                            dateInput("map_mun_date",
                                                      label = h5("Selecione a data:"),
                                                      min = as.Date(min(data_mun$date),"%Y-%m-%d"),
                                                      max = as.Date(max(data_mun$date),"%Y-%m-%d"),
                                                      value = as.Date(max(data_mun$date)),
                                                      format = "dd-mm-yyyy", 
                                                      language = "pt-BR"),
                                            h5("Notas:"), 
                                            h6(paste0("1: Os dados mais recentes nem sempre estão disponíveis para todos os municípios,",
                                                      " o que pode fazer com que municípios sem tais informações não apareçam no mapa",
                                                      " na data mais atual, mas sejam visualizados em datas anteriores.")),
                                            h5("Fonte dos dados:"),
                                            h6(HTML(paste0("<a href=\"https://brasil.io/home/\" target=\"_blank\">", "Brasil.io", "</a>"))),
                                            width = 2
                                        ), # end sidebar
                                        mainPanel(
                                            leafletOutput(outputId = 'mapa_mun1', height = 800),
                                            width = 10
                                        ) #end main panel
                                    ),
                           ) # end tab
                           
                ) # end Menu Municípios
                
    ) # end navbarPage

 ))# endlist