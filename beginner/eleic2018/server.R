#server das eleições 2018  (27-fev-2019, 10:20h)

 server <- function(input, output, session) {
  
  observe( {
    updateSelectInput(session, "color", choices = varis[[input$categoria]])
  })

  dado_filtro <- reactive({
                 validate(need(input$color, message = FALSE))
                 data1 <- dados_eleic_sec[dados_eleic_sec[,6] == input$color,] %>%
                 aggregate(QT_VOTOS ~ cod_6 + NM_VOTAVEL + DS_CARGO, data = ., FUN = sum, na.rm = T)
                 mapa <- sp::merge(municipiopolyii, data1, by.x = 'CD_GEOCMU', by.y = 'cod_6')
                 mapa
 })
 
  dado_urna <- reactive({
               validate(need(input$color, message = FALSE))
               data2 <- dados_eleic_sec[dados_eleic_sec[,6] == input$color,] %>%
               split(.,.[,10])
               temp <- dado_escola
               soma <- lapply(names(temp), 
          function(y) (sapply(row.names(temp[[y]]),
           function(x) sum(data2[[y]][data2[[y]][,2] %in% escolas_sessoes[[as.numeric(x)]],7], na.rm = T))))%>% #numero sessao / #qtedevotos
            setNames(., names(temp))
               for(i in 1:295){temp[[i]] <- data.frame(temp[[i]], 'voto_urna' = soma[[i]])}
               mapa <- purrr::map_df(temp , data.frame) %>% .[.$voto_urna > 0,] 
               mapa
               })

  #atribuindo o objeto mapa                    
   mapa <- leaflet() %>%
      addTiles() %>%
    #addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
        setView(lng =  -48.5512765, lat = -27.5947736, zoom = 7)
   
   #renderizando os mapas (sem os dados)
   output$map     <- renderLeaflet({mapa})        
    #bins <- reactive({as.vector(round(quantile(dado_filtro()$TOTAL_VOTOS, probs = c(0,0.30,0.50,0.7,0.85,0.95,1))))})
        
 observe({
   validate(need(input$color, message = FALSE))
   #req(input$color)
   teste <- dado_filtro()
   teste2 <- dado_urna()
   
   bins <- unique(as.vector(round(quantile(dado_filtro()$QT_VOTOS, probs = c(0,0.30,0.50,0.7,0.85,0.95,1), na.rm = T))))#seq(min(teste$TOTAL_VOTOS),max(teste$TOTAL_VOTOS),length  =8)
   pal <- colorBin("YlOrRd", domain =teste$QT_VOTOS, bins = bins)
   colorData <- pal(teste$QT_VOTOS)
     
   labells <- sprintf(
  "<strong>%s</strong><br/> %s: %s",# <br/> %s: %s", #  people / mi<sup>2</sup>",
 teste$Municipio, input$color, teste@data$QT_VOTOS
) %>% lapply(htmltools::HTML)

  labells2 <- sprintf(
  "<strong>%s</strong><br/> %s: %s",# <br/> %s: %s", #  people / mi<sup>2</sup>",
 teste2$escola, 'Quantidade de votos:', teste2$voto_urna
) %>% lapply(htmltools::HTML)

  if(input$radio == 1){
   leafletProxy('map')  %>% clearMarkerClusters() %>%  clearShapes() %>% clearControls() %>%
        addPolygons(data = teste, color = "#444444", fillColor =  colorData, stroke = T, smoothFactor = 0.5, fillOpacity = 0.7,
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
    leaflet::addLegend(pal = pal, values = colorData, opacity = 0.7, title = input$color,
  position = "bottomright",
        layerId="colorLegend") 
        }else{
      leafletProxy('map') %>% clearMarkerClusters() %>%  clearShapes() %>% clearControls() %>%
       addMarkers(data=teste2,
                          lng=~long, lat=~lat,
                          label= labells2,
                          popup= labells2,
                          clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
                          labelOptions = labelOptions(noHide = F,
                                                       direction = 'auto'))
                       } 
                       })          
}
