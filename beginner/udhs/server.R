 #server
 
  shinyServer(function(input, output, session) {
 
          #função para busca dos pontos
           #df_places <- eventReactive(input$atualizar,{ input$text %>% 
            # purrr::map_df(.f = get_googlemaps_data, radius = 60000) })
  
# Plotando no mapa os dados pesquisados na etapa acima
 output$map <-
           renderLeaflet({ leaflet() %>%
         addProviderTiles(providers$OpenStreetMap)  %>%  
           addPolygons(data = municipiopoly, color = "#bdbdbd",fillColor = NA, fillOpacity = 0.2,
                weight = 2.5)  %>% 
        addTiles(attribution = 'Maps by Secretaria de Estado do Planejamento (SPG)') %>% setView(lng =  -48.5512765, lat = -27.5947736, zoom = 12)
           })  

   # store the click
       #data_of_click <- input$map_shape_click

  #mostrando o output
  #  output$value <- renderPrint({ input$map_shape_click })
        
 observe({
 #  bins <- seq(min(municipiopoly@data[,input$color]),max(municipiopoly@data[,input$color]),length  =8)
    if(municipiopoly@data[,input$color] >= 1){bins <- unique(as.vector(ceiling(quantile(municipiopoly@data[,input$color], probs = c(0,0.30,0.50,0.7,0.85,0.95,0.98,1)))))}else{
       bins <- unique(as.vector(quantile(municipiopoly@data[,input$color], probs = c(0,0.30,0.50,0.7,0.85,0.95,0.98,1))))}
   pal <- colorBin("YlOrRd", domain = municipiopoly@data[,input$color], bins = bins)
   colorData <- pal(municipiopoly@data[,input$color])
   
   #dado <- df_places()
     
   labells <- sprintf(
  "<strong>%s</strong><br/> %s: %g", #  people / mi<sup>2</sup>",
 municipiopoly@data$Nome.da.UDH, input$color, municipiopoly@data[,input$color]
) %>% lapply(htmltools::HTML)

   leafletProxy('map') %>%  clearMarkers() %>% clearShapes() %>%
   addPolygons(data = municipiopoly, layerId = ~Nome.da.UDH, color = "#444444",
    fillColor =  colorData, stroke = T, smoothFactor = 0.5, fillOpacity = 0.3,
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
    addLegend(pal = pal, values = colorData, opacity = 0.7, title = paste(input$color),
  position = "bottomright",
        layerId="colorLegend")# %>%
     #addMarkers(data = dado, lng = ~long, lat = ~lat )     
     })

     dado.grafI <-  reactive({validate(need(input$map_shape_click, message = FALSE))
                              dados <- municipiopoly@data %>% .[.[,6] == input$map_shape_click[[1]],c(6,9:11)]
                              dados
                              })
       
   output$grafI <- renderC3({
    prototipoII <- dado.grafI()
    names(prototipoII)[1] <- '.id'
    prototipoII
    }) #end grafI
 
 })  #end server