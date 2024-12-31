 #server para a aba de leitos (SES)  (23-mar-20, 19:59h)
 
 #uis
 
 output$vs_slider <- renderUI({
                  sliderInput("range_casos", label = h3("Dia"),as.Date('2020-03-12'),
                   max(data_ufs[data_ufs$Codigos == 42,1], na.rm = T), 
                   value = c( max(data_ufs[data_ufs$Codigos == 42,1], na.rm = T)), step = 1)
      })
      
 output$vs_sliderII <- renderUI({
                       list(column(2,
               pickerInput("sexo", "Sexo:",
                  choices= c('Masculino' = 'M', 'Feminino' = 'F'), selected = c('M','F'),
                  options = list(`actions-box` = TRUE, `none-selected-text` = "Selecionar um município"),
                  multiple = T)
                  ),
                  column(3,
               sliderInput("range_idade", "Idade:",
                  min = 0, max = 120,
                  value = c(0,120))
                  ),
         
            column(3,
               pickerInput("macrorreg", "Macrorregiões Saúde:",
                  choices= c(levels(dado_macrorregiao$macrorregiao)), selected = levels(dado_macrorregiao$macrorregiao),
                  options = list(`actions-box` = TRUE, `none-selected-text` = "Selecionar"),
                  multiple = T) ))
                       })
 
 #!
 #!ver o filtro da base de dados ()
  
      dado_casos_ii <-     reactive({
                           req(input$range_casos)
                           if(input$periodoanalise_vs == 2){
                           dia <- seq(input$range_casos - 7, input$range_casos, by = 'day')
                           dadoi <- dado_positivo[dado_positivo$dat_sintomas_all %in% dia, ]}
                           if(input$periodoanalise_vs == 3){
                           dia <- seq(input$range_casos - 14, input$range_casos, by = 'day')
                           dadoi <- dado_positivo[dado_positivo$dat_sintomas_all %in% dia, ]}
                           if(input$periodoanalise_vs == 1){
                           dadoi <- dado_positivo[dado_positivo$dat_sintomas_all <= input$range_casos, ]}
                           #dadoi <- left_join(dadoi, pops_sc[,c(5:7)], by = 'codigo')
                           dadoi
                           })
  
    dado_casos_tabs <- reactive({req(dado_casos_ii())
                                 req(input$macrorreg)
                                 dadoi <- dado_casos_ii()
                                 dadoi <- dadoi[dadoi[,'macrorregiao'] %in% input$macrorreg,]
                                 dadoi <- dadoi[dadoi$ind_sexo %in% input$sexo,]
                                 #dadoi <- dadoi[dadoi$hospitalizado %in% input$hospitalizado,]
                                 dadoi <- subset(dadoi, dadoi$num_idade >= input$range_idade[1] &
                                          dadoi$num_idade <=   input$range_idade[2])
                                 #levels(dadoi$sexo)[dadoi$sexo == 'F'] <- 'Mulheres'
                                 #levels(dadoi$sexo)[dadoi$sexo == 'M'] <- 'Homens'
                                 dadoi
                                 })#end reactive

   dado_tab_mun <- reactive({#req(dado_casos_tab())
                             dadoi <- dado_casos_tabs()
                            dadoi  <- as.data.frame(table(dadoi[,'codigo']))
                            if(ncol(dadoi) == 1){dadoi <- data.frame('codigo' = NA, 'value' = NA)}else{
                            dadoi[,1] <- as.numeric(levels(dadoi[,1])[dadoi[,1]])
                            names(dadoi) <- c('codigo','confirmados')}
                            dadoi
                            })

    dado_tab_obito <- reactive({# req(dado_casos_tab())
                                 dadoi <- dado_casos_tabs()
                               dadoi <- subset(dadoi, ind_obito == 1)
                               dadoi <- as.data.frame(table(dadoi$codigo))
                               if(nrow(dadoi) == 0){dadoi <- data.frame('codigo' = NA, 'obitos' = NA)}else{
                                 names(dadoi) <- c('codigo', 'obito')
                                 dadoi[,1] <- as.numeric(levels(dadoi[,1])[dadoi[,1]])}
                                 dadoi
                                 })

  
   
   #output$texto <- renderPrint({head(dado_casos_tabs())})
 
   #piramide etária por sexo
   output$genderplot <- renderHigh({
                          dadoi  <- dado_casos_tabs()
                           faixa <- c('0-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54',
            '55-59','60-64','65-69','70-74','+75')
                        dadoi$faixa <- cut(dadoi$num_idade, breaks = c(0,seq(20,75, by = 5),100),right = FALSE,
                label = faixa)
                          dadoi  <- as.data.frame(table(dadoi$faixa, dadoi$ind_sexo))
                          #dadoii <- faixa
                          dadoi[,2] <- ifelse(dadoi[,2] == 'F','Mulheres','Homens')
                          dadoiii <- lapply(split(dadoi, dadoi[,2]), function(x){dado <- x
                                     dado <- list('name' = as.character(dado[nrow(dado),2]), 'data' = dado[,3])
                                     dado})
                          names(dadoiii) <- NULL
                          dadoiii[[1]][[2]] <- dadoiii[[1]][[2]]*(-1)
                          dadoiii <- list(faixa, dadoiii)
                          dadoiii
                        })

   #gadget_sexo
    
   #gráfico sintomas
   
   output$bar_sintomas <- renderHigh({
                           dadoi <- dado_casos_tabs()
                           # dadoi <-  lapply(dadoi[,c(12,15,16,19,20,21,23,24,36,34,35,41)], function(x){Casos <- table(x)[2]
                           #dadoi <-  lapply(dadoi[,c(11,14,15,18,19,20,22,23,35,33,34,40)], function(x){Casos <- table(x)[2]
                           dadoi <-  lapply(dadoi[,c(16,19,20,23:25,27,28,40,38,39,45)], function(x){Casos <- table(x)[2]
                                      if(is.na(Casos)){Casos <- 0}
                                      Casos}) %>% purrr::map_df(. ,data.frame, .id = 'col_sintomas')
                         names(dadoi)[2] <- 'Casos'
                          df_sintomas <- data.frame('col_sintomas' = names(dado_positivo)[c(16,19,20,23:25,27,28,40,38,39,45)],
                                'Sintomas' = c('Tosse','Cefaléia','Cansaço','Nosocomial','Coriza','Congestão_nasal', 'Diarréia',
                                      'Dispnéia','Febre','Dor no Corpo','Dor de Garganta','Mialgia'))
                          dadoi <- left_join(dadoi, df_sintomas, by = 'col_sintomas')
                         dadoi <- arrange(dadoi, desc(Casos))
                          converter(dadoi[,c(3,2)])
                           })
                        
   #mapa casos
     
  #mapa
  objeto_mapai <- leaflet() %>%
    setView(lat = -27.5, lng = -51, zoom = 7) %>% 
    addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ',  group = 'Black') %>%
       addLayersControl(
            baseGroups = c( "Confirmados","Óbitos"),
            options = layersControlOptions(collapsed = F), position = 'bottomleft' )  
  
   output$mapacasos <-  renderLeaflet({objeto_mapai})
   
   observe({
     req(input$menu)
     req(input$range_casos)
     if(is.na(dado_tab_mun()[1,1])){leafletProxy('mapacasos')}else{
      mapa <- sp::merge(municipiopoly, dado_tab_mun(), by.x = 'CD_GEOCMU', by.y = 'codigo') %>%
              sp::merge(., dado_tab_obito(), by.x = 'CD_GEOCMU', by.y = 'codigo') 
              
      labells <- sprintf(
  "<strong>%s</strong> %s<br/> <strong>%s</strong> %s</br>  <strong>%s</strong> %s", #  people / mi<sup>2</sup>",
 'Município: ', mapa$Municipio, 'Confirmados: ', mapa$confirmados, 'Óbitos: ',mapa$obito) %>%
 lapply(htmltools::HTML)

    # pale <- colorNumeric(palette = 'YlOrRd', domain = mapa$incidencia,
     #           na.color = "transparent")

     mapa$value <- mapa$confirmados
   if(any(input$mapacasos_groups %in% 'Confirmados')){
     mapa$value <- mapa$confirmados}

   if(any(input$mapacasos_groups %in% 'Óbitos')){
     mapa$value <- mapa$obito}


      binsi <- unique(as.vector(round(quantile(mapa$value, probs = c(0,0.30,0.50,0.75,0.9,1), na.rm = T))))

   if(length(binsi) <= 2){pali <-  colorNumeric(palette = c('yellow', 'red'),domain = 1:2,
                 na.color = "transparent")}else{
   pali <- colorBin("YlOrRd", domain =mapa$value, bins = binsi,
                na.color = "transparent")}
   colorDatai <- pali(mapa$value)

   leafletProxy('mapacasos') %>% clearShapes() %>%
    addPolylines(data = municipiopoly, color = "#f5f5f5",
        weight = 2, opacity = 0.4)  %>%
    addPolygons(data = mapa,  color = "#444444",
    fillColor =  colorDatai , stroke = F, smoothFactor = 0.5, fillOpacity = 0.7,
    weight = 1.5,highlight = highlightOptions(
    weight = 5,
    color = "#666",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labells,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto")) %>%
    addLegend(pal = pali,
     values = if(length(binsi) <= 2){unique(mapa$value)}else{colorDatai},
   title = 'Quantidade de casos:', position = "bottomright",
    layerId="colorLegend2") }
                    })      #eend map


    #----value box------#
   output$soma_casos <- renderValueBox({
      dadoi  <- dado_casos_tabs()

       valueBox(
    paste0(nrow(dadoi)),
      paste("Quantidade de casos confirmados residentes em SC"), icon = icon("global"),
      color = "blue"
    )
    })


   output$prop_h <- renderValueBox({
      dadoi  <- dado_casos_tabs()
      dadoi  <- (prop.table(table(dadoi$ind_sexo))*100) %>%
                 round(2) %>%as.data.frame()
       valueBox(
      paste0(dadoi[2,2],'%'),
      paste("Prop. Homens, com",table(dado_casos_tabs()$ind_sexo)[2],'casos'),
       icon = icon("male"),
      color = "blue"
    )
    })

    output$prop_f <- renderValueBox({
      dadoi  <- dado_casos_tabs()
      dadoi  <- (prop.table(table(dadoi$ind_sexo))*100) %>%
                 round(2) %>%as.data.frame()
       valueBox(
      paste0(dadoi[1,2],'%'),
      paste("Prop. Mulheres, com",table(dado_casos_tabs()$ind_sexo)[1],'casos'),
      icon = icon("female"),
      color = "blue"
    )
  })

   output$media_idade <- renderValueBox({
      dadoi  <- dado_casos_tabs()
      dadoi  <- mean(dadoi$num_idade, na.rm = T) %>% round(2)
       valueBox(
      dadoi,
      paste("Idade média"), icon = icon("user"),
      color = "blue"
    )
  })

 # output$qtde_internados <- renderValueBox({
 #     dadoi  <- dado_casos_tabs()
 #     dadoi  <- table(dadoi$hospitalizado)
 #      valueBox(
 #     dadoi[2],
 #     paste("Quantidade de hospitalizados"), icon = icon("hospital"),
 #     color = "blue"
 #   )
 # })

 

  #!tabela e botão download
 #estão no script na pasta shiny_vs
