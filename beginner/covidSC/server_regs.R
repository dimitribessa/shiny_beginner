  #server para a aba de territórios (18-maio-20, 12:06h)
 #.modificado em 18-mar-21 (otimização de processos)
 
 #uis
 output$regs_slider <- renderUI({
                       sliderInput("range_regional", label = h3("Dia"),min = as.Date('2020-03-12'),
                        max = max(dado_positivo[!is.na(dado_positivo$macrorregiao),'dat_sintomas_all'], na.rm = T),
      value =  max(dado_positivo[!is.na(dado_positivo$macrorregiao),'dat_sintomas_all'], na.rm = T), step = 1)
      })


 #!macrorregiões
  
 #dados base para análise
 dado_territ <- reactive({ req(input$range_regional)
                           if(input$periodoanalise_reg == 2){
                           dia <- seq(input$range_regional - 7, input$range_regional, by = 'day')}
                           if(input$periodoanalise_reg == 3){
                           dia <- seq(input$range_regional - 14, input$range_regional, by = 'day')}
                           if(input$periodoanalise_reg == 1){
                           dia <- seq(as.Date('2020-02-25'), input$range_regional, by = 'day')}
                           dado <- dado_macrorregiao[dado_macrorregiao$dia %in%dia, ]
                           dado <- left_join(dado, macro_pop[,-1], by = 'macrorregiao')
                           dado$obitos[is.na(dado$obitos)] <- 0
                           dado
                           })


   #temporalidade incidencia
   #!ajeitar nomes!
 output$lines_macrorreg <- renderHigh({
     dadoi <- dado_territ() 
     if(input$graf_regional == 1){
     dadoi <- lapply(split(dadoi, dadoi$macrorregiao), 
               function(x){
               x$incid <- round(cumsum(x$casos/x$populacao)*10^5,3)
               list('name' = x[!is.na(x[,1]),2][1], 'data' = x[,'incid'])}) %>% unname}
     if(input$graf_regional == 2){
      dadoi <- lapply(split(dadoi, dadoi$macrorregiao), 
               function(x){
               x$incid <- round(cumsum(x$obitos/x$populacao)*10^6,3)
               list('name' = x[!is.na(x[,1]),2][1], 'data' = x[,'incid'])}) %>% unname}
     names(dadoi) <- NULL
     dadoi  
 })    
     

  #ajeitar datas (dimitri 01-jun-2020)
 output$ranking_reg <- renderHigh({
                     dadoi <- dado_territ()
                     if(input$graf_regional == 1){
                     dadoi <- aggregate(casos ~macrorregiao, data = dadoi, FUN= sum, na.rm = T)}
                     if(input$graf_regional == 2){
                     dadoi <- aggregate(obitos ~macrorregiao, data = dadoi, FUN= sum, na.rm = T)}
                     names(dadoi) <- c('Macrorregião', 'Total')
                     dadoi <- arrange(dadoi, desc(Total))
                     list(dadoi[,1], list(list('data' = dadoi[,2])))
                           })

  output$macrobubble <- renderHigh({
                     dadoi <- dado_territ()
                     dadoi <- group_by(dadoi, macrorregiao) %>%
                              summarise(., letalidade = round((sum(obitos, na.rm = T)/sum(casos, na.rm = T))*100,2),
                                           incid_confirmados = sum((casos/populacao)*10^5, na.rm = T),
                                           total_obito = sum(obitos, na.rm = T)) %>% as.data.frame
                     dadoi <- left_join(dadoi, sigla_reg, by = 'macrorregiao')
                     dadoi$sigla <- as.character(levels(dadoi$sigla)[dadoi$sigla])
                     dadoi[is.na(dadoi)] <- 0
                     dadoi <- lapply(split(dadoi, dadoi$macrorregiao), function(x){
                                      list('x' = x$letalidade, 'y' = x$incid_confirmados,
                                      'z' = x$total_obito, 'name' = x$sigla, 'country' = x$macrorregiao)})
                     names(dadoi) <- NULL
                     dadoi
                     })

 #casos ativos (adicionado em 22-set-2020, 01:23h)
  output$graf_sc_ativo_macro <- renderHigh({
     dadoi <- dado_territ()
     lapply(split(dadoi, dadoi$macrorregiao), function(x){
                          list('name' = x[1,2], 'data' = x[,'ativos'])}) %>% unname
 })        

   #-----------mapa---------------
   
   output$mapa_macrorreg <-  renderLeaflet({leaflet() %>%       setView(lat = -27.5, lng = -51, zoom = 7)  %>%
    addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ',  group = 'Black') %>%
       addLayersControl(
            baseGroups = c( "Confirmados","Óbitos"),
            options = layersControlOptions(collapsed = F), position = 'bottomleft' )
        })    
     
 #mapa casos
   observe({
     req(input$menu)
     req(input$range_regional)
     
     dadoi <- dado_territ()
     dadoi <- group_by(dadoi, macrorregiao) %>%
                              summarise(., incid_obito = sum((obitos/populacao)*10^6, na.rm = T),
                                           incid_confirmados = sum((casos/populacao)*10^5, na.rm = T)
                                           ) %>% as.data.frame
      mapai <- sp::merge(mapa_macro, dadoi, by = 'macrorregiao')

      labells <- sprintf(
  "<strong>%s</strong> %s<br/> <strong>%s</strong> %s</br>  %s %s", #  people / mi<sup>2</sup>",
 'Macrorregião: ', mapai$macrorregiao, 'Incidência casos: ', mapai$incid_confirmados, 'Incidência óbito: ', mapai$incid_obito) %>% lapply(htmltools::HTML)
   
   mapai$incidencia <- mapai$incid_confirmados
   if(any(input$mapa_macrorreg_groups %in% 'Confirmados')){
     mapai$incidencia <- mapai$incid_confirmados}

   if(any(input$mapa_macrorreg_groups %in% 'Óbitos')){
     mapai$incidencia <- mapai$incid_obito}



   binsi <- unique(as.vector(quantile(mapai$incidencia, probs =  c(0,0.10,0.30,0.50,0.75,0.9,1), na.rm = T)))

   if(length(binsi) <= 2){pali <-  colorNumeric(palette = c('yellow', 'red'),domain =1:2,
                 na.color = "transparent")}else{
   pali <- colorBin("YlOrRd", domain =mapai$incidencia, bins = binsi,
                na.color = "transparent") }

   colorDatai <- pali(mapai$incidencia)

   leafletProxy('mapa_macrorreg') %>%
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

                    }) 
   
 #!regionais saúde

  dado_territ_reg <- reactive({ req(input$range_regional)
                           if(input$periodoanalise_reg == 2){
                           dia <- seq(input$range_regional - 7, input$range_regional, by = 'day')}
                           if(input$periodoanalise_reg == 3){
                           dia <- seq(input$range_regional - 14, input$range_regional, by = 'day')}
                           if(input$periodoanalise_reg == 1){
                           dia <- seq(as.Date('2020-02-25'), input$range_regional, by = 'day')}
                           dado <- dado_reg_saude[dado_reg_saude$dia %in%dia, ]
                           dado <- left_join(dado, reg_pop, by = 'reg_saude')
                           dado$obitos[is.na(dado$obitos)] <- 0
                           dado
                           })

   #temporalidade incidencia
   #!ajeitar nomes!
 output$lines_regionais <- renderHigh({
     dadoi <- dado_territ_reg() 
     dadoi <- subset(dadoi, reg_saude %in% input$list_regionais)
     if(input$graf_regional == 1){
      dadoi <- lapply(split(dadoi, dadoi$reg_saude), function(x){
               x$incid <- round(cumsum(x$casos/x$populacao)*10^5,3)
               list('name' = x[!is.na(x[,1]),2][1], 'data' = x[,'incid'])}) %>% unname}
     if(input$graf_regional == 2){
      dadoi <- lapply(split(dadoi, dadoi$reg_saude), function(x){
               x$incid <- round(cumsum(x$obitos/x$populacao)*10^6,3)
               list('name' = x[!is.na(x[,2]),1][1], 'data' = x[,'incid'])})}
     names(dadoi) <- NULL
     dadoi  
 })    

  #ajeitar datas (dimitri 01-jun-2020)
 output$ranking_regionais <- renderHigh({
                     dadoi <- dado_territ_reg()
                     if(input$graf_regional == 1){
                     dadoi <- aggregate(casos ~reg_saude, data = dadoi, FUN= sum, na.rm = T)}
                     if(input$graf_regional == 2){
                     dadoi <- aggregate(obitos ~reg_saude, data = dadoi, FUN= sum, na.rm = T)}
                     names(dadoi) <- c('Reg.Saúde', 'Total')
                     dadoi <- arrange(dadoi, desc(Total))
                     list(dadoi[,1], list(list('data' = dadoi[,2])))
                           })

  output$macrobubble_regionais <- renderHigh({
                     dadoi <- dado_territ_reg()
                     dadoi <- group_by(dadoi, reg_saude) %>%
                              summarise(., letalidade = round((sum(obitos, na.rm = T)/sum(casos, na.rm = T))*100,2),
                                           incid_confirmados = sum((casos/populacao)*10^5, na.rm = T),
                                           total_obito = sum(obitos, na.rm = T)) %>% as.data.frame
                     dadoi <- left_join(dadoi, sigla_regioes, by = 'reg_saude')
                     dadoi$sigla <- as.character(levels(dadoi$sigla)[dadoi$sigla])
                     dadoi[is.na(dadoi)] <- 0
                     dadoi <- lapply(split(dadoi, dadoi$reg_saude), function(x){
                                      list('x' = x$letalidade, 'y' = x$incid_confirmados,
                                      'z' = x$total_obito, 'name' = x$sigla, 'country' = x$reg_saude)})
                     names(dadoi) <- NULL
                     dadoi
                     })


 #gráficos de casos ativos
 output$graf_sc_ativo_reg <- renderHigh({
     dadoi <- dado_territ_reg()
     lapply(split(dadoi, dadoi$reg_saude), function(x){
                          list('name' = x[1,2], 'data' = x[,'ativos'])}) %>% unname
 })        

   #-----------mapa---------------

   output$mapa_reg_saude <-  renderLeaflet({leaflet() %>%       setView(lat = -27.5, lng = -51, zoom = 7)  %>%
    addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ',  group = 'Black') %>%
       addLayersControl(
            baseGroups = c( "Confirmados","Óbitos"),
            options = layersControlOptions(collapsed = F), position = 'bottomleft' )
        })

 #mapa casos
   observe({
     req(input$menu)
     req(input$range_regional)

     dadoi <- dado_territ_reg()
    dadoi <- group_by(dadoi,reg_saude) %>%
                              summarise(., incid_obito = sum((obitos/populacao)*10^6, na.rm = T),
                                           incid_confirmados = sum((casos/populacao)*10^5, na.rm = T)
                                           ) %>% as.data.frame
     
      mapai <- sp::merge(mapa_regionais, dadoi, by = 'reg_saude')

      labells <- sprintf(
  "<strong>%s</strong> %s<br/> <strong>%s</strong> %s</br>  %s %s", #  people / mi<sup>2</sup>",
 'Regional: ', mapai$reg_saude, 'Incidência casos: ', mapai$incid_confirmados, 'Incidência óbito: ', mapai$incid_obito) %>% lapply(htmltools::HTML)

   mapai$incidencia <- mapai$incid_confirmados
   if(any(input$mapa_reg_saude_groups %in% 'Confirmados')){
     mapai$incidencia <- mapai$incid_confirmados}

   if(any(input$mapa_reg_saude_groups %in% 'Óbitos')){
     mapai$incidencia <- mapai$incid_obito}



   binsi <- unique(as.vector(quantile(mapai$incidencia, probs =  c(0,0.10,0.30,0.50,0.75,0.9,1), na.rm = T)))

   if(length(binsi) <= 2){pali <-  colorNumeric(palette = c('red, yellow'),domain =1:2,
                 na.color = "transparent")}else{
   pali <- colorBin("YlOrRd", domain =mapai$incidencia, bins = binsi,
                na.color = "transparent") }

   colorDatai <- pali(mapai$incidencia)

   leafletProxy('mapa_reg_saude') %>%
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

                    })



 