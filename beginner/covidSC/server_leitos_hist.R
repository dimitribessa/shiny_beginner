 #server para a aba de leitos (SES)  
 #!
 #lista leitos nefermaria
  #enfermaria <- c('CLINICO ADULTO', 'CLINICO PEDIATRICO', 'ISOLAMENTO ADULTO', 'ISOLAMENTO PEDIATRICO')
  #uti <- c('UTI ADULTO', 'UTI PEDIATRICA')
  
 base_dados_leitos_hist <- reactive({if(isTRUE(input$iscovid_leito)){
                           dadoi <- lapply(serie_ocup, function(x){dado <- subset(x, leito_covid == 'true')
                                                       dado})}else{
                           dadoi <- serie_ocup}
                           dadoi
                           })
  
 #dados_grafs
 dado_leitos_grafs <- reactive({
                      dadoi <- base_dados_leitos_hist()
                      if(input$painel_regs_series == 'Macrorregião'){
                      localidade <- 'macrorregiao.atendimento'}
                      if(input$painel_regs_series == 'Região'){
                      localidade <- 'reg_saude.atendimento'}
                    #  if(input$painel_regs_leito == 'Município'){
                     # localidade <- 'municipio.atendimento'}
                      dadoi  <- lapply(dadoi, function(x){
                                         lapply(split(x, x[,localidade]),function(z){
                                            ocupado <- nrow(z[z$status %in% c('ocupado', 'higienizacao'),])
                                            total   <- nrow(z)
                                            perc_ocupado <- round(ocupado*100/total,2)
                                            data.frame(ocupado, total, perc_ocupado)                                            
                                            }) %>% purrr::map_df(., data.frame, .id = 'localidade')
                                            })# %>% purrr::map_df(., data.frame, .id = 'data') 
                      dadoi})
 
#base movimentação nos leitos
 base_dados_leitos_movs <- reactive({if(isTRUE(input$iscovid_leito)){
                           dadoi <-  subset(dado_hist_mov, leito_covid == 'true')}else{
                           dadoi <- dado_hist_mov}
                           dadoi
                           }) 
  # aqui tb tem as informações de permanência                   
  dado_leitos_movs <- reactive({
                      dadoi <- base_dados_leitos_movs()
                      if(input$painel_regs_series == 'Macrorregião'){
                      localidade <- 'macrorregiao.atendimento'}
                      if(input$painel_regs_series == 'Região'){
                      localidade <- 'reg_saude.atendimento'}
                      if(input$painel_regs_series == 'Município'){
                      localidade <- 'municipio.atendimento'}
                      dadoi  <- subset(dadoi, #get(localidade) == input$list_serie &
                                (data_disp >= input$dateRange_serie[1] &
                                          data_disp <= input$dateRange_serie[2]) &
                                       status == 'ocupado')
                      #mudando o nome do vetor para localidade
                      names(dadoi)[which(names(dadoi) %in% localidade)] <- 'localidade'
                      dadoi})
 #mudando as opções do selectinput
   observe({
      if(input$painel_regs_series == 'Macrorregião'){
       dadoi  <- levels(dado_hist_mov$macrorregiao.atendimento)}
      if(input$painel_regs_series == 'Região'){
       dadoi  <- levels(dado_hist_mov$reg_saude.atendimento)}
      if(input$painel_regs_series == 'Município'){
       dadoi  <- levels(dado_hist_mov$municipio.atendimento)}
     
                            
       updateSelectInput(session,
                  "list_serie",label =  "Localidade:",
                  choices= dadoi, selected = dadoi[1])                    
         
    })    
 
 output$lines_serie <- renderHigh({
                                 dadoi <- dado_leitos_grafs()
                                 xaxis <- names(dadoi)
                                 dadoi <- purrr::map_df(dadoi, data.frame, .id = 'data')
                                 dadoi <- lapply(split(dadoi, dadoi$localidade), function(x){
                                            list('name' = x[!is.na(x[,2]),2][1], 'data' = x[,5])}) %>% unname
                                 list(xaxis,
                                       dadoi) %>% unname
                                 })
 
  output$lines_ocup_serie <- renderHigh({
                                 dadoi <- dado_leitos_grafs()
                                 xaxis <- names(dadoi)
                                 dadoi <- purrr::map_df(dadoi, data.frame, .id = 'data')
                                 dadoi <- subset(dadoi, localidade == input$list_serie)
                                 list(xaxis,list(
                                       list('name' = 'Leitos ocupados',
                                                 'data' = dadoi$ocupado,
                                                 'type' = 'area',
                                                # 'color' = 'blue',
                                                 'fillOpacity' = 0.3),
                                       list('name' = 'Leitos totais',
                                                 'data' = dadoi$total))) %>% unname
                                 })
 
 

  output$cont_chart_serie <- renderHigh({
                            dadoi <- dado_leitos_grafs()
                            dadoi <-  dadoi[[as.character(input$data_serie)]]
                           dadoi <- arrange(dadoi, localidade)
                           #unico <- data.frame('Local' = unique(dadoi[,1]))
                           dadoii <- lapply(split(dadoi,dadoi$localidade), function(x){
                                     list('name' = x[1,1], 'data' = x[,'perc_ocupado'])}) %>% unname
                                     
                           list(dadoi[,1],list(list('name' = '% ocupação','data' = dadoi[,4]) ))
                           })
  
  output$chart_tempo_serie <- renderHigh({
                            dadoi <- dado_leitos_movs()
                           dadoi <- arrange(dadoi, localidade)
                           dadoi <- aggregate(tempo_uso ~ localidade, data = dadoi, FUN = mean, na.rm = T)
                           dadoi[,2] <- round(dadoi[,2],2)
                           list(dadoi[,1],list(list('name' = 'Dias','data' = dadoi[,2]) ))
                           })
                           
   
  #---
 


  #!mapas
  mapabase_serie <- leaflet() %>%
    addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ')  %>%
        setView(lat = -27.5, lng = -51, zoom = 7) %>%
       addLayersControl(
            baseGroups = c( "Ocupados", "Total leitos", 'Tx. Ocupação'),
            options = layersControlOptions(collapsed = F), position = 'bottomleft' )  
       
  
  output$mapaleitos_serie_macro <-  renderLeaflet({mapabase_serie})
  output$mapaleitos_serie_reg <-  renderLeaflet({mapabase_serie})
  output$mapaleitos_serie_munic <-  renderLeaflet({mapabase_serie})
      
 
        
  #!mapa macrorregiões
  observe({
   if(input$painel_regs_series != 'Macrorregião'){NULL}else{
 
   dadoi <- dado_leitos_grafs()
   dadoi <-  dadoi[[as.character(input$data_serie)]]
   
    mapa <- sp::merge(mapa_macro, dadoi, by.x = 'macrorregiao', by.y = 'localidade')

        labells <- sprintf(
  "<strong>%s</strong> %s<br/> %s %s<br/> %s %s<br/> %s %s ", #  people / mi<sup>2</sup>",
 'Macrorregião: ', mapa$macrorregiao, 'Total leitos: ', mapa$total,
 'Ocupados: ',mapa$ocupado, 'Tx. Ocupação: ', paste0(mapa$perc_ocupado,'%')) %>% lapply(htmltools::HTML)


     mapa$incidencia <- mapa$total
     paleta <- c('white', 'blue')
     cores <- 'Blues'
     titulo <- 'Total leitos'
   
   if(any(input$mapaleitos_serie_macro_groups %in% 'Ocupados')){
     mapa$incidencia <- mapa$ocupado
     paleta <- c('yellow', 'orange')
     cores <- "YlOrRd"
     titulo <- 'Ocupados'}

   if(any(input$mapaleitos_serie_macro_groups %in% 'Tx. Ocupação')){
     mapa$incidencia <- mapa$perc_ocupado
     paleta <- c('yellow', 'orange')
     cores <- "YlOrRd"
     titulo <- 'Tx. Ocupação'}

   if(any(input$mapaleitos_serie_macro_groups %in% 'Total leitos')){
      mapa$incidencia <- mapa$total
     paleta <- c('white', 'blue')
     cores <- 'Blues'
     titulo <- 'Total leitos'}

   binsi <- unique(as.vector(quantile(mapa$incidencia, probs = c(0,0.30,0.50,0.65,0.8,0.95,1), na.rm = T)))
    if(length(binsi) <= 2){pali <-  colorNumeric(palette = paleta,domain = 1:2,
                na.color = "transparent")}else{
   pali <- colorBin(cores, domain =mapa$incidencia, bins = binsi,
                na.color = "transparent")}
   colorDatai <- pali(mapa$incidencia)


          leafletProxy('mapaleitos_serie_macro') %>%
             clearShapes() %>%
              setView(lat = -27.5, lng = -51, zoom = 7)  %>%
               addPolygons(data = mapa,  color = "#444444",
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
    direction = "auto"))  %>%
    addLegend(pal = pali,  values = if(length(binsi) <= 2){unique(mapa$incidencia)}else{colorDatai},
   title = titulo, position = "bottomright",
    layerId="colorLegend2")
}
                   }) #end observe macrorregiões            
  
   observe({
    if(input$painel_regs_series != 'Região'){NULL}else{
   
    dadoi <- dado_leitos_grafs()
   dadoi <-  dadoi[[as.character(input$data_serie)]]
   
    mapa <- sp::merge(mapa_regionais, dadoi, by.x = 'reg_saude', by.y = 'localidade')

        labells <- sprintf(
  "<strong>%s</strong> %s<br/> %s %s<br/> %s %s<br/> %s %s ", #  people / mi<sup>2</sup>",
 'Região: ', mapa$reg_saude, 'Total leitos: ', mapa$total,
 'Ocupados: ',mapa$ocupado, 'Tx. Ocupação: ', paste0(mapa$perc_ocupado,'%')) %>% lapply(htmltools::HTML)


     mapa$incidencia <- mapa$total
     paleta <- c('white', 'blue')
     cores <- 'Blues'
     titulo <- 'Total leitos'
   
   if(any(input$mapaleitos_serie_reg_groups %in% 'Ocupados')){
     mapa$incidencia <- mapa$ocupado
     paleta <- c('yellow', 'orange')
     cores <- "YlOrRd"
     titulo <- 'Ocupados'}

   if(any(input$mapaleitos_serie_reg_groups %in% 'Tx. Ocupação')){
     mapa$incidencia <- mapa$perc_ocupado
     paleta <- c('yellow', 'orange')
     cores <- "YlOrRd"
     titulo <- 'Tx. Ocupação'}

   if(any(input$mapaleitos_serie_reg_groups %in% 'Total leitos')){
      mapa$incidencia <- mapa$total
     paleta <- c('white', 'blue')
     cores <- 'Blues'
     titulo <- 'Total leitos'}

   binsi <- unique(as.vector(quantile(mapa$incidencia, probs = c(0,0.30,0.50,0.65,0.8,0.95,1), na.rm = T)))
    if(length(binsi) <= 2){pali <-  colorNumeric(palette = paleta,domain = 1:2,
                na.color = "transparent")}else{
   pali <- colorBin(cores, domain =mapa$incidencia, bins = binsi,
                na.color = "transparent")}
   colorDatai <- pali(mapa$incidencia)


          leafletProxy('mapaleitos_serie_reg') %>%
             clearShapes() %>%
              setView(lat = -27.5, lng = -51, zoom = 7)  %>%
               addPolygons(data = mapa,  color = "#444444",
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
    direction = "auto"))  %>%
    addLegend(pal = pali,  values = if(length(binsi) <= 2){unique(mapa$incidencia)}else{colorDatai},
   title = titulo, position = "bottomright",
    layerId="colorLegend2")
        } #end if
                   }) #end observe regionais    
           