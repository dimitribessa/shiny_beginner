#-----------------------------------------------------------------------------#
#---------------shiny V8 (08-mar-2019, 01:06h)--------------------------------#
#-----------------------------------------------------------------------------#

 shinyServer(function(input, output, session){

     #ajustando as informações dos inputs
   info <- reactive({ bounds <- input$mapi_bounds
                      latRng <- range(bounds$north, bounds$south)
                      lngRng <- range(bounds$east, bounds$west)

                      dado <- subset(teste,
                      lat <= bounds$north & lat >= bounds$south &
                      long <= bounds$east & long >= bounds$west)
                      dado <- as.data.frame(table(dado$tamanho))
                      dado[,1] <- as.character(levels(dado[,1])[dado[,1]])
                      names(dado) <- c('.id','value')
                      dado
                       })

  output$grafqtde <- renderC3({info()})
   #output$texto <- renderPrint({info()})
                                       
  #atribuindo o objeto mapa                    
   mapa <- leaflet() %>%
    addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
        setView(lat =  -14.235, lng = -51.9253, zoom = 4) %>%
        addPolylines(data = estadopoly, color = "#f5f5f5",
        weight = 2.5) 
   
   #renderizando os mapas (sem os dados)
   output$mapi     <- renderLeaflet({mapa})

  observe({
 # pal <- colorFactor(palette = c('#7fc97f','#beaed4','#fdc086','#ffff99','#386cb0','#f0027f'),
  #       domain = teste$tamanho)

  labells <- sprintf(
  "<strong>%s:</strong> <br/> %s", #  people / mi<sup>2</sup>",
 "Quantidade de empregados",teste$Qtd.Vínculos.Ativos) %>% lapply(htmltools::HTML)

  leafletProxy('mapi')%>%
       addCircleMarkers(data=teste[!is.na(teste[,'lat']),],
                          lng=~long, lat=~lat,
   #                        color = ~pal(tamanho),
                          clusterOptions = markerClusterOptions(),      #removeOutsideVisibleBounds = F
                          label = labells,
                          labelOptions = labelOptions(
                                                       style = list("font-weight" = "normal", padding = "3px 8px"),
                                                       textsize = "12px",
                                                       maxWidth = '200px',
                                                       direction = "auto"))
      
    })#observe mapi

  #plotando mapa dos icms
  output$icms <- renderC3({
                  dado <- testei
                  names(dado)[1] = '.id'
                  dado})
                  
    #plotando sazonalidade
  output$sazonalidade <- renderC3({
                  dado <- sazonalidade
                  names(dado)[1] = '.id'
                  dado})

})#end code