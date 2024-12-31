 #server para a aba incidências (01-maio-20) 
 
 #uis
 
 output$incid_slider <- renderUI({
                        sliderInput("range_incid", label = h3("Dia"),min(data_ufs[,1], na.rm = T),
                         max(data_ufs[,1], na.rm = T), value = max(data_ufs[,1], na.rm = T), step = 1,
                  animate = FALSE)
                  })
                  
 output$incid_pickerestado <- renderUI({ 
                  pickerInput("list_estado", "Estados:",
                  choices= c(levels(data_ufs$UFs)), selected = c('Santa Catarina', 'Rio de Janeiro'),
                  options = list(`actions-box` = TRUE, `none-selected-text` = "Selecionar um estado"),
                  multiple = T)
                  })                 
                  
 output$incid_pickermun <- renderUI({
                            pickerInput("lista_municipio", "Municípios:",
                            choices= unique(as.character(dado_positivo$municipio)), selected = c('Florianópolis', 'Joinville'),
                            options = list(`actions-box` = TRUE, `none-selected-text` = "Selecionar um município"),
                            multiple = T)
                           })
 

 dados_incid_base <- reactive({
                           
                           dadoi <- dado_positivo[dado_positivo$dat_sintomas_all <= input$range_incid, ]
                           dadoi})



 

 #base de dados para os gráficos de indicência (06-maio-2020, 10:57h)
 dado_incidsc_all <- function(){dadoi <- dado_positivo
                           casos <- group_by(dadoi, dat_sintomas_all) %>%
                                          summarise(., confirmados = n()) %>%
                                          mutate(., incid_confirmados = cumsum(confirmados)) %>%
                                          as.data.frame
                           obitos <- group_by(dadoi[dadoi$ind_obito == 1,], dat_sintomas_all) %>%
                                          summarise(., obito = n()) %>% 
                                          mutate(., incid_obito = cumsum(obito)) %>%
                                          as.data.frame

                           dadoi <- full_join(casos, obitos, by = 'dat_sintomas_all')
                           dadoi[,c(2:5)] <- (dadoi[,c(2:5)]*10^5/sum(pops_sc[,5])) %>% round(2)

                           coleta <- group_by(dado_positivo, dat_coleta) %>%
                                          summarise(., testes = n()) %>%
                                          mutate(., incid_testes = cumsum(testes)) %>%
                                          as.data.frame
                           coleta[,c(2:3)] <- (coleta[,c(2:3)]*10^5/sum(pops_sc[,5])) %>% round(2)

                           #dadoi <- full_join(dadoi, coleta, by = c('dat_sintomas_all' = 'dat_coleta'))
                           names(dadoi)[1] <- 'date'
                           dadoi$Codigos <- 42
                           dadoi$UFs <- 'Santa Catarina'
                           dadoi <- arrange(dadoi, date)
                           dadoi <- dadoi %>% tidyr::fill(incid_confirmados, incid_obito, .direction = 'down')

                           dadoi
                           }

  dado_incidsc_all <- dado_incidsc_all()

 #dados para serem trabalhados
  dado_ufs <- reactive({ dadoi <- data_ufs[(data_ufs$date <= input$range_incid) | data_ufs$Codigos != 42, ]
                           dadoi
                           })
 
 #dados_estados (para mapa)
 dado_estado <- reactive({dadoi <- dado_ufs()
                          dadoi <- dadoi[dadoi$date == input$range_incid & dadoi$Codigos != 42,]
                          dadoisc <- dado_incidsc_all[dado_incidsc_all[,1] == input$range_incid,]
                          if(nrow(dadoisc) == 0){dadoisc <- dado_incidsc_all[dado_incidsc_all[,1] == input$range_incid,]}
                          names(dadoi)[c(6,8,11,12,16,17)] <- c('obito','confirmados','incid_obito','incid_confirmados',
                          'testes','incid_testes')
                          dadoi <- dadoi[,c(1,25,24,6,8,11,12)]
                          dadoi <- dplyr::bind_rows(dadoi, dadoisc)
                          dadoi[,-1]
                          })
 
 #gráfico crescimento incidencia estado
 seq_estado <- reactive({dadoi <- dado_ufs()
                         #dadoi$UFs <- as.character(levels(dadoi$UFs)[dadoi$UFs])
                         dadoi <- dadoi[dadoi$Codigos != 42,]
                         dadoisc <- subset(dado_incidsc_all, date >= as.Date('2020-02-28'))
                         names(dadoi)[c(6,8,11,12,16,17)] <- c('obito','confirmados','incid_obito','incid_confirmados',
                          'testes','incid_testes')
                         dadoi <- dadoi[,c(1,25,24,6,8,11,12)]
                         dadoi <- dplyr::bind_rows(dadoi, dadoisc)
                         dadoi <- dplyr::filter(dadoi, UFs %in% input$list_estado)
                         dadoi <- dadoi[dadoi$date <= input$range_incid,]
                         dadoi <-  purrr::map(split(dadoi, dadoi$UFs), function(x){dado <- x
                                          dado$seqdias <- 1:nrow(dado)
                                          dado})# %>% tidyr::spread(., key = 'UFs', value = 'incidencia')
                           
                          dadoi})
 

 #gráfico crescimento incidencia município
 seq_municipio <- reactive({dadoi <- dados_incid_base()
                           if(is.factor(dadoi$municipio)){
                           dadoi$municipio <- as.character(levels(dadoi$municipio)[dadoi$municipio])}
                           dadoi <- dadoi[dadoi$municipio %in% input$lista_municipio,]
                           dadoi <- lapply(split(dadoi, dadoi$municipio), function(x){
                           dadoii <- x
                           dias <- seq(min(dadoii$dat_sintomas_all),max(dadoii$dat_sintomas_all), by = 'day') %>%
                           as.data.frame
                           names(dias) <- 'dat_sintomas_all'
                           casos <- group_by(dadoii, codigo, municipio, dat_sintomas_all) %>%
                                          summarise(., casos = n())
                           obitos <- group_by(dadoii[dadoii$ind_obito == 1,], dat_sintomas_all) %>%
                                          summarise(., obitos = n())
                           dadoii <- full_join(casos, obitos, by = c('dat_sintomas_all'))
                           dadoii$obitos[is.na(dadoii$obitos)] <- 0
                           dadoii <- mutate(dadoii, casos_acum = cumsum(casos),
                                                    obitos_acum = cumsum(obitos))
                           dadoii <- left_join(dias, dadoii, by = 'dat_sintomas_all')
                           dadoii <- dadoii %>% tidyr::fill(names(.))
                           dadoii <- left_join(dadoii, pops_sc[,c(5,6)], by = 'codigo') %>% as.data.frame
                           dadoii[,c(6,7)] <- (dadoii[,c(6,7)]*10^5/dadoii[,8]) %>% round(4)
                            dadoii})
                          dadoi})
 

  
 
 
 #dados_municipios_sc_mapa
 #confirmados
 mapa_incid_confirmsc <- reactive({ req(input$range_incid)
                                    dadoi <- dados_incid_base()
                                    dadoi <- as.data.frame(table(dadoi$codigo))
                                    names(dadoi) <- c('codigo', 'casos')
                                    dadoi$casos[is.na(dadoi$casos)] <- 0
                                    #dadoi$casos <- cumsum(dadoi$casos)
                                    dadoi[,1] <- as.numeric(levels(dadoi[,1])[dadoi[,1]])
                                    dadoi <- left_join(dadoi, pops_sc[,c(4:7)], by = 'codigo')
                                    dadoi$incid_casos <- with(dadoi, round((casos/populacao)*10^5,2))
                                    dadoi
                          })
 
 #obitos
 mapa_incid_obitosc <- reactive({    req(input$range_incid)
                                    dadoi <- dados_incid_base()
                                    dadoi <- dadoi[dadoi$ind_obito == 1, ]
                                    if(nrow(dadoi) == 0){dadoi <- data.frame('codigo' = NA, 'obito' = NA, 'incid_obito' = NA)}else{
                                    dadoi <- as.data.frame(table(dadoi$codigo))
                                    names(dadoi) <- c('codigo', 'obito')
                                    dadoi$obito[is.na(dadoi$obito)] <- 0
                                    #dadoi$obito <- cumsum(dadoi$obito)
                                    dadoi[,1] <- as.numeric(levels(dadoi[,1])[dadoi[,1]])
                                    dadoi <- left_join(dadoi, pops_sc[,c(4:7)], by = 'codigo')
                                    dadoi$incid_obito <- with(dadoi, round((obito/populacao)*10^5,2))}
                                    dadoi
                          })
 

                   
    #-------- Estatisticas descritivas ----------------------------------------#

# incidência por estaod
 output$rankbar <- renderHigh({
    dado_histograma <- dado_estado()
    if(input$incid_estado == 1){dado_histograma$incidencia <- dado_histograma[,c(6)]}
    if(input$incid_estado == 2){dado_histograma$incidencia <- dado_histograma[,c(5)]}
    #if(input$incid_estado == 3){dado_histograma$incidencia <- dado_histograma[,c(8)]}
    #dado_histograma$UFs <- as.character(levels(dado_histograma$UFs)[dado_histograma$UFs])
    dado_histograma <- arrange(dado_histograma, desc(incidencia))
    dado_histograma <- dado_histograma[,c(2,7)]
    media <- round(mean(dado_histograma[,2], na.rm = T),2)
    names(dado_histograma) <-  c('Estado','Tx.Incidência')
    list(dado_histograma[,1], 
      list(list('name' = 'Tx.Incidência', 'data' = dado_histograma[,2])),
        mean(dado_histograma[,2], na.rm = T),
        paste0('Valor médio nacional: ',media)   )#end list
    
 })
 

  #incidencia por municipio
 output$rankbarII <- renderHigh({
    if(input$incidmunicipio == 1){dado_histograma <- mapa_incid_confirmsc()[,c(3,6)]}
    if(input$incidmunicipio == 2){dado_histograma <- mapa_incid_obitosc()[,c(3,6)]}
   # if(input$incidmunicipio == 3){dado_histograma <- mapa_incid_testesc()[,c(3,6)]}
    names(dado_histograma) <- c('Municipio', 'Tx.Incidência')
    dado_histograma <- arrange(dado_histograma, desc(Tx.Incidência))
    media <- round(mean(dado_histograma[,2], na.rm = T),2)
    list(dado_histograma[,1], 
      list(list('name' = 'Tx.Incidência', 'data' = dado_histograma[,2])),
        mean(dado_histograma[,2], na.rm = T),
        paste0('Valor médio no estado: ',media)
           )#end list
     })
     
  #temporalidade incidencia
 output$linechartI <- renderHigh({
     dadoi <- seq_estado() 
     if(input$incid_estado == 1){
      dadoi <- lapply(dadoi, function(x){list('name' = x[1,3], 'data' = x[,7])})}
     if(input$incid_estado == 2){
      dadoi <- lapply(dadoi, function(x){list('name' = x[1,3], 'data' = x[,6])})}
    # if(input$incid_estado == 3){
     # dadoi <- lapply(dadoi, function(x){list('name' = x[1,3], 'data' = x[,9])})}
     names(dadoi) <- NULL
     dadoi  
 })                    
 
   output$timechartII <- renderHigh({
     dadoi <- dado_ufs()
     dadoi <- dadoi[dadoi$Codigos != 42,]
     dadoisc <- dado_incidsc_all
     names(dadoi)[c(6,8,11,12,16,17)] <- c('obito','confirmados','incid_obito','incid_confirmados',
     'testes','incid_testes')
     dadoi <- dadoi[,c(1,25,24,6,8,11,12)]
     dadoi <- dplyr::bind_rows(dadoi, dadoisc)
     dadoi <- dplyr::filter(dadoi, UFs %in% input$list_estado)
     dadoi <- dadoi[dadoi$date <= input$range_incid,]
    
     if(input$incid_estado == 1){dadoi <- dadoi[,c(1,3,7)]}
     if(input$incid_estado == 2){dadoi <- dadoi[,c(1,3,6)]}
   #  if(input$incid_estado == 3){dadoi <- dadoi[,c(1,3,9)]}
     dadoii <- unique(dadoi$date)
     dadoii <- dadoii[order(dadoii)]
     dadoi <- lapply(split(dadoi, dadoi$UFs), function(x){
                                   dado <- left_join(as.data.frame(dadoii),x, by = c('dadoii' = 'date'))
                                   dado[,c(2,3)]})
     names(dadoi) <- NULL
     dadoiii <- lapply(dadoi, function(x){dado <- x
                                     list('name' = as.character(dado[nrow(dado) -1,1]), 'data' = dado[,2])})
     dadoiii <- list(dadoii, dadoiii) 
     dadoiii
 
 }) 
 
 
 #municipio
 #temporalidade incidencia
 output$linechartmunI <- renderHigh({
     dadoi <- seq_municipio()
     if(input$incidmunicipio == 1){
      dadoi <- lapply(dadoi, function(x){list('name' = x[1,3], 'data' = x[,6])})}
     if(input$incidmunicipio == 2){
      dadoi <- lapply(dadoi, function(x){list('name' = x[1,3], 'data' = x[,7])})}
   #  if(input$incidmunicipio == 3){
    #  dadoi <- lapply(dadoii, function(x){list('name' = x[1,2], 'data' = x[,5])})}
     names(dadoi) <- NULL
     dadoi  
 })                    
 
   output$timechartmunII <- renderHigh({
     dadoi <- seq_municipio()
     dadoi <- purrr::map_df(dadoi, data.frame)
     dadoi <- dplyr::filter(dadoi, municipio %in% input$lista_municipio)
     if(input$incidmunicipio == 1){dadoi <- dadoi[,c(1,2,3,6)]}
     if(input$incidmunicipio == 2){dadoi <- dadoi[,c(1,2,3,7)]}
     names(dadoi)[4] <- 'value'
     #if(input$incidmunicipio == 3){dadoi <- dadoi[,c(2,3,5)]}
     dadoii <- unique(dadoi$dat_sintomas_all)
     dadoii <- dadoii[order(dadoii)]
     dadoi <- lapply(split(dadoi, dadoi$municipio), function(x){
                                   dado <- left_join(as.data.frame(dadoii),x, by = c('dadoii' = 'dat_sintomas_all'))
                                   #dado <- dado %>% tidyr::fill(value)
                                   dado[,c(3,4)]})
     names(dadoi) <- NULL
     dadoiii <- lapply(dadoi, function(x){dado <- x
                                     nome <- dado[!is.na(dado[,1]),1][1]
                                     list('name' = nome, 'data' = dado[,2])})
     dadoiii <- list(dadoii, dadoiii) 
     dadoiii
 
 }) 
 
 
 #output$teste <- renderPrint({any(input$mapa_inci_groups %in% 'Confirmados')})    
 
 #mapa
   output$mapa_inci <-  renderLeaflet({leaflet()  %>%  setView(lat = -17.52, lng = -40.52, zoom = 4)  %>% 
    addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ',  group = 'Black') %>%
       addLayersControl(
            baseGroups = c( "Confirmados","Óbitos"),
            options = layersControlOptions(collapsed = F), position = 'bottomleft' )  
        })
    
      output$mapa_incii <-  renderLeaflet({leaflet() %>%       setView(lat = -27.5, lng = -51, zoom = 7)  %>%
    addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ',  group = 'Black') %>%
       addLayersControl(
            baseGroups = c( "Confirmados","Óbitos"),
            options = layersControlOptions(collapsed = F), position = 'bottomleft' )
        })    
     
 
 #mapa casos
   observe({
     req(input$menu)
     req(input$range_incid)
     if(nrow(dado_estado()) == 0){NULL}else{
      estado <- dado_estado()
      mapa <- merge(estados_sf, estado, by.x = 'code_state', by.y = 'Codigos') %>%
              merge(., pop_estado, by.x = 'code_state', by.y = 'estados')

   labells <- sprintf(
  "<strong>%s</strong> %s<br/> <strong>%s</strong> %s</br> %s %s</br>  %s %s", #  people / mi<sup>2</sup>",
 'Estado: ', mapa$UFs, 'População: ', mapa$POPULACAO,'Tx. Incidência casos: ',
  mapa$incid_confirmados, 'Tx. Incidência óbitos: ', mapa$incid_obito) %>%
 lapply(htmltools::HTML)

    mapa$incidencia <- mapa$incid_confirmados
   if(any(input$mapa_inci_groups %in% 'Confirmados')){
     mapa$incidencia <- mapa$incid_confirmados}

   if(any(input$mapa_inci_groups %in% 'Óbitos')){
     mapa$incidencia <- mapa$incid_obito}

  
   binsi <- unique(as.vector(quantile(mapa$incidencia, probs = c(0,0.10,0.30,0.50,0.75,0.9,1), na.rm = T)))
    if(length(binsi) <= 2){pali <-  colorNumeric(palette = c('yellow', 'orange'),domain = 1:2,
                na.color = "transparent")}else{
   pali <- colorBin("YlOrRd", domain =mapa$incidencia, bins = binsi,
                na.color = "transparent")}
   colorDatai <- pali(mapa$incidencia)

   leafletProxy('mapa_inci') %>%
    clearShapes() %>%
    setView(lat = -17.52, lng = -40.52, zoom = 4)  %>%
    addPolygons(data = mapa,  color = "#444444",
    fillColor =  colorDatai , stroke = T, smoothFactor = 0.5, fillOpacity = 0.7,
    weight = 2.5,highlight = highlightOptions(
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
    addLegend(pal = pali, values = if(length(binsi) <= 2){unique(mapa$incidencia)}else{colorDatai},
   title = 'Tx. de incidência\n(100.000 habitantes)', position = "bottomright",
    layerId="colorLegend2")
     }
                    })      #end estados

 observe({
    req(input$painel_inci)
    req(input$range_incid)
      mapai <- sp::merge(municipiopoly, mapa_incid_confirmsc()[,c('codigo','incid_casos', 'populacao')], by.x = 'CD_GEOCMU', by.y = 'codigo') %>%
               sp::merge(., mapa_incid_obitosc()[,c('codigo','incid_obito')], by.x = 'CD_GEOCMU', by.y = 'codigo')

      labells <- sprintf(
  "<strong>%s</strong> %s<br/> %s %s</br> %s %s</br>  %s %s", #  people / mi<sup>2</sup>",
 'Município: ', mapai$Municipio, 'População: ',mapai$populacao,
 'Incidência casos: ', mapai$incid_casos, 'Incidência óbito: ', mapai$incid_obito) %>%
  lapply(htmltools::HTML)
   
   mapai$incidencia <- mapai$incid_casos
   if(any(input$mapa_incii_groups %in% 'Confirmados')){
     mapai$incidencia <- mapai$incid_casos}

   if(any(input$mapa_incii_groups %in% 'Óbitos')){
     mapai$incidencia <- mapai$incid_obito}

   
   binsi <- unique(as.vector(quantile(mapai$incidencia, probs =  c(0,0.10,0.30,0.50,0.75,0.9,1), na.rm = T)))

   if(length(binsi) <= 2){pali <-  colorNumeric(palette = c('yellow', 'red'),domain =1:2,
                 na.color = "transparent")}else{
   pali <- colorBin("YlOrRd", domain =mapai$incidencia, bins = binsi,
                na.color = "transparent") }

   colorDatai <- pali(mapai$incidencia)

   leafletProxy('mapa_incii') %>%
   clearShapes() %>%
   setView(lat = -27.5, lng = -51, zoom = 7)  %>%
    addPolygons(data = mapai,  color = "#444444",
    fillColor =  colorDatai,
     stroke = T, smoothFactor = 0.5, fillOpacity = 0.7,
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
    addLegend(pal = pali,  values = if(length(binsi) <= 2){unique(mapai$incidencia)}else{colorDatai},
   title = 'Tx. de incidência \n(100.000 habitantes)', position = "bottomright",
    layerId="colorLegend2")

                    }) #end obsseve municidpios 