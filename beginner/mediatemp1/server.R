 shinyServer(function(input, output, session){
      
 
   
   dado <-  reactive({medias_final[medias_final$Municipio == input$municipio ,c(1,2,4:6)] 
                     })
   
   output$Chart1 <- renderHighchart({
            dadoi <- dado()
            dadoi <- dadoi[order(as.numeric(dadoi[,1])),]
            dadoi[,3:5] <- round(dadoi[,3:5],2)
            dadoii <- split(dadoi, dadoi$decada)
            if(isTRUE(dadoii[[1]][1,3] == dadoii[[1]][1,4])){
            p <- highchart() %>% hc_chart(type = 'line') %>%
            hc_xAxis(categories = levels(dadoi[,1])) %>%   
            hc_add_series(data = dadoii[[1]][,3], name = '60s') %>% 
            hc_add_series(data = dadoii[[2]][,3], name = '70s') %>% 
            hc_add_series(data = dadoii[[3]][,3], name = '80s') 
            }else{
            p <- highchart() %>% hc_chart(type = 'columnrange') %>%
            hc_xAxis(categories = levels(dadoi[,1])) %>%
            hc_add_series(data = toJSONArray2(dadoii[[1]][,-c(1,2,3)], names = F, json = F), name = '60s') %>% 
            hc_add_series(data = toJSONArray2(dadoii[[2]][,-c(1,2,3)], names = F, json = F), name = '70s') %>%
            hc_add_series(data = toJSONArray2(dadoii[[3]][,-c(1,2,3)], names = F, json = F), name = '80s')}
            p  %>% hc_subtitle(text = "MNTP - Temperatura Mínima a 2 m da Superfície [°C] (Eta MIROC 20Km)")
            
            
   }) #output$Chart1
 
 #!testando input do click no mapa
  # store the click
    #   data_of_click <- input$map_shape_click

  #mostrando o output
    # output$value <- renderPrint({ input$map_shape_click })
   
        #renderizando mapa
   output$map     <- renderLeaflet({ leaflet() %>%
      addTiles() %>%
     # addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
     addProviderTiles("CartoDB.Positron") %>%
        setView(lng =  -51.114965, lat = -27.0628367, zoom = 7)})
   
   observe({
   
   leafletProxy('map') %>%  
   addPolygons(data = municipiopoly, layerId = ~Municipio, color = "#444444",
    fillColor =  'grey80', stroke = T, smoothFactor = 0.5, fillOpacity = 0.3,
    weight = 1.5,highlight = highlightOptions(
    weight = 5,
    color = "red",
    fillColor = 'red',
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = ~Municipio,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto"))
     
   })#end observe

  observeEvent(input$map_shape_click, {
	p <- input$map_shape_click
	if(!is.null(p$id)){
		if(is.null(input$municipio)) updateSelectInput(session, "municipio", selected=p$id)
		if(!is.null(input$municipio) && input$municipio!=p$id) updateSelectInput(session, "municipio", selected=p$id)
	}
})



})#end code