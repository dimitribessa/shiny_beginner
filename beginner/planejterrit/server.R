#planejamento territorial (19-dez-2018, 00:46h)

server <- shinyServer(function(input, output, session) {

  #ui dinâmico
   output$ui <- renderUI({

    switch(input$opcao,
           'idhm' = selectInput("varidhm", "Indicador:",choices = c(names(dadosidh)[3:8]), selected = names(dadosidh)[3]),
           'ivs'  = selectInput("varivs", "Indicador:",choices =  c(names(ivs)[3:22]), selected = names(ivs)[3]),
           'pib'  =  fluidRow(
                    column(3,
                     selectInput('ano','Ano:', c(2002:2016), selected = 2016)),
                    column(5,
                     selectInput('series',
                     'Indicador:', choices = c('Agropecuária' = 'agropecuaria', 'Indústria' = 'industria',
                                            'Serviço' = 'servico', 'Administração Pública' = 'adm_pub',
                                            'Impostos' = 'imposto','PIB' = 'sum_pib'), selected = 'sum_pib'))
                                            )
                     )#switch

   })#renderui

   
  #atribuindo o objeto mapa                    
   output$map <- renderLeaflet({leaflet() %>%
        # addProviderTiles(providers$OpenStreetMap)  %>%  
        addTiles(urlTemplate = 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_nolabels/{z}/{x}/{y}.png') %>% 
        setView(lng =  -48.5512765, lat = -27.5947736, zoom = 7)%>% 
        addPolygons(data = municipiopoly, color = "#636363",fillColor = NA, fillOpacity = 0.3,
        weight = 2.5)       
        })#renderLeaflet 


 dado <- reactive({#validate(need(input$opcao, message = FALSE))
                   if(input$opcao == 'idhm'){
                                  p <- dadosidh[,c('codigo','Municipio',input$varidhm)]}else{
                   if(input$opcao == 'ivs'){
                                  p <- ivs[,c('codigo','Municipio',input$varivs)]}else{
                   if(input$opcao == 'pib'){
                                  p <- series.data[series.data$ano == input$ano,c('codigo','Municipio',input$series)]
                                  }}}
              p})

 dadomapa <- reactive({dadoi <- dado()
                       sp::merge(municipiopoly, dadoi[,-2], by = 'codigo')
                       })#dadomapa

 observeEvent(input$action,{
   teste <- dadomapa()

    if(teste@data[1,13] >= 1){bins <- unique(as.vector(ceiling(quantile(teste@data[,13], probs = c(0,0.30,0.50,0.7,0.85,0.95,0.98,1),na.rm = T))))}else{
       bins <- unique(as.vector(quantile(teste@data[,13], probs = c(0,0.30,0.50,0.7,0.85,0.95,0.98,1),na.rm = T)))}
    
   pal <- colorBin("YlOrRd", domain = teste@data[,13], bins = bins)
   colorData <- pal(teste@data[,13])
     
   labells <- sprintf(
  "<strong>%s</strong><br/> %s: %s" , #  people / mi<sup>2</sup>",
 teste$Municipio, names(teste@data)[13], teste@data[,13]) %>% lapply(htmltools::HTML)

   leafletProxy('map') %>% 
        addPolygons(data = teste, color = "#444444", fillColor =  colorData, stroke = T, smoothFactor = 0.5, fillOpacity = 0.8,
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
    addLegend(pal = pal, values = colorData, opacity = 0.7, title = names(teste@data)[13],
  position = "bottomright",
        layerId="colorLegend") 
                       
  }) #observer
                                                     
#  output$view <- renderTable({summary(dado()[,3])}) 
 
 #gráfico1
 output$graf1 <- renderbarC3({
                   dadoi <- dado()[,-1]
                   dadoi <- dadoi[order(dadoi[,2], decreasing = T),]
                   #dadoi <- reshape2::melt(dadoi[,-1], id.vars = 'Municipio')
                   names(dadoi)[1] <- c('.id')
                   dadoi

                  })
                  
 #gráficoII
 output$graf2 <- renderPlotly({
                prototipoII <- ivs[,c('Municipio', input$ivsI)] %>%
                 setNames(.,c('Municipio', 'value'))
                grafico <- ggplot(prototipoII, aes(x = reorder(Municipio, value), y = value)) + 
 geom_col(aes(text = paste(Municipio, value)),alpha = 0.7)  + scale_fill_manual(values = c('#f03b20','#feb24c'))  + xlab('') + ylab('')  +  
 geom_hline(aes(yintercept = mean( value, na.rm = T)), linetype = 2, colour = 'blue') +
 geom_hline(aes(yintercept = mean( value, na.rm = T) + sd( value, na.rm = T)), linetype = 6, colour = 'red')  +
  geom_hline(aes(yintercept = mean( value, na.rm = T) + 2*sd( value, na.rm = T)), colour = 'red') +
  annotate('text', x = 4, y = texto[,input$ivsI], label = row.names(texto), size = 3, vjust = 1) +
   theme(axis.text.x = element_text(angle=45, hjust=1, size = 8))
    
  ggplotly(grafico, tooltip = 'text') %>% layout(autosize=TRUE)
    })
    
    #graficoIII
    
    dado.grafIII <- reactive({if(input$ivsII == 'IVS'){dados <- ivs[,c(1,4:6)]}
                              if(input$ivsII == "IVS.Infraestrutura.Urbana"){dados <- ivs[,c(1,7:9)]}
                              if(input$ivsII == "IVS.Capital.Humano"){dados <- ivs[,c(1,10:17)]}
                              if(input$ivsII == "IVS.Renda.e.Trabalho"){dados <- ivs[,c(1,18:22)]}
                              dados                                               
                              })
       
   output$graf3 <- renderPlotly({
   prototipoII <- dado.grafIII()
 graficoII <- melt(prototipoII[prototipoII[,1] == input$cidade,], id.vars = c("Municipio"))
 graficoIII <- ggplot(graficoII, aes(x = variable, y = value, fill = variable)) + geom_col(aes(text = paste(variable,': ',value)),alpha = 0.6) +
              geom_hline(aes(yintercept = mean(value, na.rm = T)), linetype = 6, colour = 'red') +xlab('') + ylab('') + theme(legend.position = 'none', legend.title = element_blank(), axis.text.x = element_blank()) 

              ggplotly(graficoIII, tooltip = 'text')  %>% layout(autosize = TRUE)
                                 })


    
#adicionando gráfico I da série de tempo
  #gráfico diversos municípios
   series.dataI <- reactive({#validate(need(input$multmunicipios, message = FALSE))
                             series.data[series.data$Municipio %in% input$multmunicipios, ]})

      output$seriesI <-renderbarC3({
        dadoi <- series.dataI()[,c('ano','Municipio',input$varseries[1])]
        names(dadoi) <- c('.id','Municipio','value')
        dadoi <- tidyr::spread(dadoi, value = value, key = Municipio)
        dadoi
      }) #end output$seriesI
                                 
   #gráfico diversos indicadores
   series.dataII <- reactive({#validate(need(input$varseries, message = FALSE),
                               #        need(input$multmunicipios, message = FALSE))
                    series.data[series.data$Municipio %in% input$multmunicipios[1], c('ano',input$varseries)]
   
   })
      output$seriesII <- renderbarC3({
        dadoi <- series.dataII()
        names(dadoi)[1] <- c('.id')
        dadoi
      }) #end output$seriesII
 
 }) #end