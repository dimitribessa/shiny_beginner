 #objetos aba de médias (11-dez-2019 (14:58h))
 
 #renderizando a div do gráfico
  output$grafico <- renderUI({if(input$vari == 1){graf <- barhighOutput("Chart1")}
                              if(input$vari != 1){graf <- linehighOutput('Chart2')}
                              graf
                    })
                    
  #gráfico precipitação
  
  dados_prec <- reactive({ 
                  id_mun <- municipiopoly@data[municipiopoly@data[,4] == input$municipio,1]
                  dado <- all_prec_mun[[as.numeric(input$modeloIII)]]
                  dado <- lapply(dado, function(z){
                          purrr::map_df(z, function(x){dadoi <- subset(x, ID == id_mun)
                                                       dadoi})})
                  names(dado) <- c('2010-2015', '2015-2019', '2020-2024', '2025-2029',
                                   '2030-2034', '2035-2040')
                 
                  lapply(1:6, function(x){
                            list('name' = names(dado)[x], 'data' = round(as.matrix(dado[[x]][,-1]),2))
                                      })
                                      })
  
  output$Chart2 <- renderHigh({dados_prec()})
      
 
 #gráfico temporal
  dados_range <- reactive({
                  id_mun <- municipiopoly@data[municipiopoly@data[,4] == input$municipio,1]
                  dado <- all_minmax[[as.numeric(input$modeloIII)]]
                  dado <- lapply(dado, function(z){
                          purrr::map_df(z, function(x){dadoi <- subset(x, ID == id_mun)
                                                       dadoi[,-1]})})
                  names(dado) <- c('2010-2015', '2015-2019', '2020-2024', '2025-2029',
                                   '2030-2034', '2035-2040')
                 
                  lapply(1:6, function(x){
                            list('name' = names(dado)[x], 'data' = round(as.matrix(dado[[x]]),2))
                                      })
                                      
                  })#end reactive
 
  output$Chart1 <- renderHigh({
                  dados_range() })



  #mapa medias
  output$mapmedia <- renderLeaflet({ leaflet()   %>%
            addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ',  group = 'Black')   %>%  
        setView(lng =  -48.5512765, lat = -27.5947736, zoom = 7) %>%
          addPolylines(data = municipiopoly, color = "#f5f5f5",
        weight = 2, opacity = 0.2)
        })  #end mapamedias
        
  #dados média mapa
  dado_mapmedia <- reactive({
                 if(input$vari == 2){dado <- all_prec_mun[[as.numeric(input$modeloIII)]][[as.numeric(input$anos_media)]][[as.numeric(input$meses)]]}
                 if(input$vari == 1){dado <- all_minmax[[as.numeric(input$modeloIII)]][[as.numeric(input$anos_media)]][[as.numeric(input$meses)]]}
                   dado
                   })

  observe({
   dado <- dado_mapmedia()

   mapa <- sp::merge(municipiopoly, dado, by.x = 'OBJECTID', by.y = 'ID')
   
   if(input$vari == 1){
   bins <- unique(as.vector(quantile(mapa$media_min, probs = c(0,0.05,0.30,0.50,0.85,0.95,1), na.rm = T)))
   pal <- colorBin("YlOrRd", domain = mapa$media_min, bins = bins)
   colorData <- pal(mapa$media_min)

   labells <- sprintf(
  "<strong>%s</strong><br/>: %s",# <br/> %s: %s", #  people / mi<sup>2</sup>",
 mapa$Municipio,  mapa$media_min
) %>% lapply(htmltools::HTML)

   bins1 <- unique(as.vector(quantile(mapa$media_max, probs = c(0,0.05,0.30,0.50,0.85,0.95,1), na.rm = T)))
   pal1 <- colorBin("YlOrRd", domain = mapa$media_max, bins = bins1)
   colorData1 <- pal(mapa$media_max)

   labells1 <- sprintf(
  "<strong>%s</strong><br/>: %s",# <br/> %s: %s", #  people / mi<sup>2</sup>",
 mapa$Municipio,  mapa$media_max
) %>% lapply(htmltools::HTML)

  leafletProxy('mapmedia') %>%
     clearShapes() %>%
        addPolygons(data = mapa, group = 'Mínimo', color = "#444444", fillColor =  colorData, stroke = T, smoothFactor = 0.5, fillOpacity = 0.7,
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

    addPolygons(data = mapa, group = 'Máximo', color = "#444444", fillColor =  colorData1, stroke = T, smoothFactor = 0.5, fillOpacity = 0.7,
    weight = 1.5,highlight = highlightOptions(
    weight = 5,
    color = "#666",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labells1,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto")) %>%

    addLegend(pal = pal, values = colorData, opacity = 0.7, title = 'Temperatura:',
  position = "bottomright",
        layerId="colorLegend", group = 'Mínimo') %>%
   addLegend(pal = pal1, values = colorData1, opacity = 0.7, title = 'Temperatura:',
  position = "bottomright",
        layerId="colorLegend", group = 'Máximo')  %>%
        addLayersControl(
          baseGroups = c("Mínimo", "Máximo"),
         options = layersControlOptions(collapsed = FALSE)
        )
     } #end if1
     
  
 if(input$vari == 2){
   bins <- unique(as.vector(quantile(mapa$media, probs = c(0,0.05,0.30,0.50,0.85,0.95,1), na.rm = T)))
   pal <- colorBin("RdYlBu", domain = mapa$media, bins = bins)
   colorData <- pal(mapa$media)

   labells <- sprintf(
  "<strong>%s</strong><br/>: %s",# <br/> %s: %s", #  people / mi<sup>2</sup>",
 mapa$Municipio,  mapa$media
) %>% lapply(htmltools::HTML)

  leafletProxy('mapmedia') %>%
     clearShapes() %>% clearControls() %>%
        addPolygons(data = mapa, color = "#444444", fillColor =  colorData, stroke = T, smoothFactor = 0.5, fillOpacity = 0.7,
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
    addLegend(pal = pal, values = colorData, opacity = 0.7, title = 'mm:',
  position = "bottomright",
        layerId="colorLegend")
     } #end if2
     
      }) #end observe
  