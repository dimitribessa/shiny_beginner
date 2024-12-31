 #server teste slider (17-nov-2019)
 
 server <- function(input, output, session) {

  
   #renderizando os mapas
        output$mapii <- renderLeaflet({ leaflet()   %>%
            addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ',  group = 'Black')   %>%  
        setView(lng =  -48.5512765, lat = -27.5947736, zoom = 7) %>%
          addPolylines(data = municipiopoly, color = "#f5f5f5",
        weight = 2, opacity = 0.2) %>%
    syncWith("maps")}) #mapa anteriori
        output$map <- renderLeaflet({ leaflet()   %>%
            addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ',  group = 'Black')   %>%  
        setView(lng =  -48.5512765, lat = -27.5947736, zoom = 7) %>%
          addPolylines(data = municipiopoly, color = "#f5f5f5",
        weight = 2, opacity = 0.2) %>%
    syncWith("maps")})  #mapa posteriori
    
    combineWidgets('mapii', 'map')
    
    dados_ant <- reactive({
                           if(input$variavelI == 1){allraster <- all_raster_med}
                           if(input$variavelI == 2){allraster <- all_raster_max}
                           if(input$variavelI == 3){allraster <- all_raster_min}
                           if(input$variavelI == 4){allraster <- all_raster_prec}
                           if(input$variavelI == 5){allraster <- all_raster_precdia}
                           allraster
                           })
                           
    dados_post <- reactive({if(input$variavelI == 1){allraster <- all_raster_med}
                           if(input$variavelI == 2){allraster <- all_raster_max}
                           if(input$variavelI == 3){allraster <- all_raster_min}
                           if(input$variavelI == 4){allraster <- all_raster_prec}
                           if(input$variavelI == 5){allraster <- all_raster_precdia}
                           allraster
                           })
    
    
    observe({
        dado_anterior <- dados_ant()
         if(as.numeric(input$anos_ant) < 7){
                         validate(need(!is.null(input$modeloI), ''))
                         dado_anterior <-  dado_anterior[[as.numeric(input$modeloI)]][[as.numeric(input$anos_ant)]][[as.numeric(input$periodo)]]
                         }
         if(as.numeric(input$anos_ant) >= 7 & as.numeric(input$anos_ant) < 14){
                         dado_anterior <-   dado_anterior[[3]][[as.numeric(input$anos_ant)-6]][[as.numeric(input$periodo)]]
                         }
         if(as.numeric(input$anos_ant) == 14){
                         dado_anterior <-   dado_anterior[[4]][[as.numeric(input$periodo)]]
                         }
         if(as.numeric(input$anos_ant) == 15){
                         validate(need(!is.null(input$modeloI), ''))
                         dado_anterior <- dado_anterior[[as.numeric(input$modeloI) + 4]][[as.numeric(input$periodo)]]
                         }
                         
                         
        dado_posterior <- dados_post()
         if(as.numeric(input$anos_post) < 7){
                         validate(need(!is.null(input$modeloII), ''))
                         dado_posterior <-  dado_posterior[[as.numeric(input$modeloII)]][[as.numeric(input$anos_post)]][[as.numeric(input$periodo)]]}
         if(as.numeric(input$anos_post) >= 7 & as.numeric(input$anos_post) < 14){
                         dado_posterior <-   dado_posterior[[3]][[as.numeric(input$anos_post)-6]][[as.numeric(input$periodo)]]
                         }
         if(as.numeric(input$anos_post) == 14){
                         dado_posterior <-   dado_posterior[[4]][[as.numeric(input$periodo)]]
                         }
         if(as.numeric(input$anos_post) == 15){
                         validate(need(!is.null(input$modeloII), ''))
                         dado_posterior <- dado_posterior[[as.numeric(input$modeloII) + 4]][[as.numeric(input$periodo)]]
                         }
                         
                
        r1 <- raster(t(dado_anterior), xmn=-57, xmx=-46.05, ymn=-32, ymx=-23.85, crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0")) #t(teste_var[,,10])
        r2 <- raster(t(dado_posterior), xmn=-57, xmx=-46.05, ymn=-32, ymx=-23.85, crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
 
        f1 <- flip(r1, direction = 'y') 
        f2 <- flip(r2, direction = 'y') 
        
        #valores para paleta de cores
        if(min(values(f1)) < min(values(f2))){minimo <- min(floor(values(f1)))}else{minimo <- min(floor(values(f2)))}
        if(min(values(f1)) > min(values(f2))){maximo <- max(ceiling(values(f2)))}else{maximo <- max(ceiling(values(f1)))}

        val <- as.numeric(c(minimo:maximo))
        
        if(input$variavelI == 4 | input$variavelI == 5){
            pale <- colorNumeric(palette = colorRamps::matlab.like2(length(val)), val,
                na.color = "transparent")}else{
            pale <- colorNumeric(palette = c('blue', 'green4', 'yellow', 'red'), val,
                na.color = "transparent")}
        
        #fazendo os valores em diferença no mapa à direita
        f3 <- f2
        values(f3) <- values(f2) - values(f1)
        val1 <- as.numeric(c(min(floor(values(f3))):max(ceiling(values(f3)))))
               if(input$variavelI == 4 | input$variavelI == 5){
               pal1 <- colorNumeric(palette = colorRamps::matlab.like2(length(val1)), val1,
                na.color = "transparent")}else{
               pal1 <- colorNumeric(palette = c('blue', 'green4', 'yellow', 'red'), val1,
                na.color = "transparent")}
       
        
        
        #valor da transparência        
        transparencia <- as.numeric(input$decimal)

        leafletProxy('mapii') %>% clearImages()   %>%
  addRasterImage(f1,colors = pale, opacity = transparencia)
                
        leafletProxy('map') %>% clearImages()   %>% clearControls() %>%
  addRasterImage(f2, colors =pale, opacity = transparencia, group = 'Valor') %>%
  addRasterImage(f3, colors =pal1, opacity = transparencia, group = 'Diferença', layerId = 'values') %>%
  addLegend(pal = pale, values = val,
   title = if(input$variavelI == 4 | input$variavelI == 5){"mm "}else{'ºC'}, position = "bottomright", layerId="colorLegend") %>%
   addLegend(pal = pal1, values = val1,
   title = if(input$variavelI == 4 | input$variavelI == 5){"mm (dif)"}else{'ºC (dif)'}, position = "bottomright", 
   group = 'Diferença', layerId="colorLegend2") %>%

  addLayersControl(baseGroups = c("Valor", "Diferença"),
               options = layersControlOptions(collapsed = F))
 
 })#end observe
 
 #------------------------------------------------------------------#
 #server para objetos da aba de médias------------------------------#
 #------------------------------------------------------------------#
 source('server_medias.R', local = T, encoding = "UTF-8")$value 
  
 #------------------------------------------------------------------#
 #output do modal --------------------------------------------------#
 #------------------------------------------------------------------#
  source('modal.R', local = T)$value
    } #end server
