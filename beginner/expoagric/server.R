
server <- shinyServer(function(input, output, session) {

  dado <- export

  ds <- reactive({data1 <- dado
  if(input$municipio != 'Tudo' ){data1   <- data1[data1$NOME  == input$municipio,]}
  if(input$pais != 'Tudo' ){data1   <- data1[data1$NO_PAIS    == input$pais,]}
  if(input$produto != 'Tudo'){data1 <- data1[data1$Prod.SH4   == input$produto,]}
  data1})

  #menu interativo de pais e municipio
  observe({
    hei1 <- input$pais
    hei5 <- input$municipio
    hei6 <- input$produto

    dados<-ds()

    choice1 <-c('Tudo', unique(dados$NO_PAIS))
    choice3 <-c('Tudo',unique(dados$NOME))
    choice4 <-c('Tudo',unique(dados$Prod.SH4))

    updateSelectInput(session,"pais",choices=choice1,selected=hei1)
    updateSelectInput(session,"municipio",choices=choice3,selected=hei5)
    updateSelectInput(session,"produto",choices=choice4,selected=hei6)
  })

  #para os dados de gráfico barra
  #!ainda não incluso os volumes #
  #gráfico ranking

  dg2 <- reactive({data1 <- ds()
  # if(input$checkpais){graf <-  aggregate(as.numeric(KG_LIQUIDO) ~ NO_PAIS, data = data1, FUN = sum, na.rm= T)}else{
  graf <-  aggregate(as.numeric(VL_FOB) ~ NO_PAIS + x + y + x.country + y.country, data = data1, FUN = sum, na.rm= T)
  graf  %>% setNames(., c('País', 'x', 'y', 'x.country', 'y.country', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>%
    mutate(., País =  País, Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
  })

  dg3 <- reactive({data1 <- ds()
  # if(input$checkproduto){graf <-  aggregate(as.numeric(KG_LIQUIDO) ~Prod.SH4, data = data1, FUN = sum, na.rm= T)}else{
  graf <-  aggregate(as.numeric(VL_FOB) ~ Prod.SH4, data = data1, FUN = sum, na.rm= T)
  graf %>% setNames(., c('Produto.SH2', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>%
    mutate(., Prod.SH2 =  paste0(substr(Produto.SH2,1,25),'(...)'), Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
  })

  dg4 <- reactive({data1 <- ds()
  graf <-  aggregate(as.numeric(VL_FOB) ~ NOME, data = data1, FUN = sum, na.rm= T) %>%
    setNames(., c('Município', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>%
    mutate(., Município =  Município, Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
  graf})

  #dados para gráfico barras com dados mensais
  dg5 <- reactive({data1 <- ds()
  graf <-  aggregate(as.numeric(VL_FOB) ~ CO_MES, data = data1, FUN = sum, na.rm= T) %>%
    setNames(., c('Cod_mes', 'Soma_expo')) %>%
    mutate(., Mês = as.factor(c('Jan','Fev','Mar','Abr','Maio','Jun','Jul','Ago','Set','Out','Nov','Dez')),
           Cod_mes = factor(Cod_mes))
  graf })

  #tabela resumo dos dados (26-dez-17, 17:42h)
  dt1 <- reactive({tabprop <- dado
  if(input$produto != 'Tudo'){tabprop <- tabprop[tabprop$Prod.SH4 == input$produto,]}
  tabprop <- aggregate(as.numeric(VL_FOB) ~ NOME, data = tabprop, FUN = sum, na.rm = T) %>%
    setNames(., c('Município', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>%
    mutate(., Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
  tabprop <- tabprop[tabprop == input$municipio,]
  resumo <- data.frame('Variáveis' = c('Município', 'Produto SH2', '% Estado','Ranking Estado','Valor Total (US$)'),
                       'Valores'   = c(input$municipio, input$produto, tabprop[1,'Prop'],tabprop[1,'Ranking'],tabprop[1,'Soma_expo']))
  resumo
  })

  #plotando os dados-----------------------#
  output$gplotII <- renderPlotly({
    theme_set(theme_minimal())
    data1 <- dg2()
    graf2 <- ggplot(data1, aes(x = reorder(País,Soma_expo), y = Soma_expo, group = País)) +
      geom_col(aes(text = paste('País: ',País,if(input$checkpais){'<br>Volume (T):'}else{'<br>Soma_expo (US$):'}, Soma_expo, '<br>Proporção:', Prop,'%', '<br>Ranking: ',Ranking)), alpha = .7, fill = '#de2d26', width = if(input$pais == 'Tudo'){NULL}else{.5}) +  xlab('') + ylab('') +
      coord_flip() +  theme(axis.text.x = element_text(hjust = 1, size = 5))

    ggplotly(graf2, tooltip = 'text') %>% layout(title = paste0('Ranking dos países destinos das exportações'))
  })

  output$gplotIII <- renderPlotly({
    theme_set(theme_minimal())
    data1 <- dg3()
    graf2 <- ggplot(data1, aes(x = reorder(Prod.SH2,Soma_expo), y = Soma_expo, group = Prod.SH2)) +
      geom_col(aes(text = paste('Produto: ',Produto.SH2,if(input$checkproduto){'<br>Volume (T):'}else{'<br>Soma_expo (US$):'}, Soma_expo, '<br>Proporção:', Prop,'%', '<br>Ranking: ',Ranking)), alpha = .7, fill = '#de2d26', width = if(input$produto == 'Tudo'){NULL}else{.5}) +  xlab('') + ylab('') +
      coord_flip() +  theme(axis.text.x = element_text(hjust = 1, size = 5))

    # %>%layout(title = 'Ranking dos produtos exportados')
    ggplotly(graf2, tooltip = 'text') %>% layout(title = paste0('Ranking dos produtos exportados'))
  })



  #Gráfico Barra mensal
  output$ggplotIV <- renderPlotly({
    theme_set(theme_minimal())
    data1 <- dg5()
    graf2 <- ggplot(data1, aes(x = Cod_mes, y = Soma_expo)) + geom_col(aes(text = paste('Mês: ',Mês,'<br>Soma_expo (US$):', Soma_expo)),alpha = .7, fill = '#2b8cbe')  + ylab('')  +geom_smooth(aes(y = Soma_expo, x = 1:12), method= 'lm')

    ggplotly(graf2) %>%layout(title = 'Valor Mensal', dragmode = 'pan')
  })

  #Quadro resumo
  output$view <- renderTable({
    dt1()
  })

  #plotando mapa

  #renderizando os mapas (sem os dados)
  output$mapa     <- renderLeaflet({mapa})

  #criando os lines
  linha <- reactive({dado <- dg2()
  lapply(1:nrow(dado),
         function(i){Lines(list(Line(rbindlist(list(dado[i,2:3], dado[i,4:5])))), as.character(i))}) %>% SpatialLines(.)})

  mapa_mun <- reactive({dado <- dg4()
  sp::merge(municipiopoly, dado, by.y = 'Município', by.x = 'Municipio') %>%
    subset(., !is.na(.$Ranking))})

  #plotando mapa

  mapa <- leaflet() %>%
    addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ', attribution = 'Maps by Secretaria de Estado do Planejamento') %>%
    setView(lng =  -48.5512765, lat = -27.5947736, zoom = 2)
    
  mapaii <- leaflet() %>%
    addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ', attribution = 'Maps by Secretaria de Estado do Planejamento') %>%
    setView(lng =  -48.5512765, lat = -27.5947736, zoom = 7)

  observe({
    if(nrow(dg2()) == 0)
      return(mapa)

    labells <- sprintf(
      "<strong>%s</strong> %s<br/> %s %s", #  people / mi<sup>2</sup>",
      'País: ', dg2()$País, 'Valor (US$): ', dg2()$Soma_expo) %>% lapply(htmltools::HTML)

    labells2  <- sprintf(
      "<strong>%s</strong> %s<br/> %s %s<br/> %s %s", #  people / mi<sup>2</sup>",
      'Município: ', mapa_mun()$Municipio, 'Valor (US$): ', mapa_mun()$Soma_expo, 'Ranking: ',mapa_mun()$Ranking) %>%
      lapply(htmltools::HTML)

    leafletProxy('mapa')  %>% clearMarkers() %>% clearGroup('c') %>% clearGroup('d') %>%
      addPolylines(data = linha(),color = "green",
                   weight = 2, group = 'c')  %>%
      addCircleMarkers(data = dg2(), lng = ~x.country, lat = ~y.country, weight = 5,
                       radius = ~Soma_expo/10^7,
                       color  = 'red', fillOpacity = 0.8,
                       label  = labells,
                       labelOptions = labelOptions(
                         style = list("font-weight" = "normal", padding = "3px 8px"),
                         textsize = "12px",
                         maxWidth = '200px',
                         direction = "auto")) %>%
    addPolygons(data = mapa_mun(), layerId = ~Municipio, 
    fillColor =  'red', stroke = T, smoothFactor = 0.5, fillOpacity = 0.3,
    weight = 1.5,highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labells2,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto"), group = 'd') 
    
     }) #observe

 #-----------------------------------------------------------------------------#
 #---------------------pib agronegócio-----------------------------------------#
 #-----------------------------------------------------------------------------#
  output$map <- renderLeaflet({mapaii})
  
  pib <- reactive({dado <- data_pib[data_pib[,1] == input$ano,c('cod_mun',input$pib,'va_total')]
                   if(input$checkbox == TRUE){dado[,2] <- round(dado[,2]/dado[,3],4)}
                   dado
          })#reactive
    
  observe({
  mapa_pib <- sp::merge(municipiopoly, pib(), by.x = 'CD_GEOCMU', by.y = 'cod_mun')
 #  bins <- seq(min(mapa_pib@data[,input$color]),max(mapa_pib@data[,input$color]),length  =8)
    if(mapa_pib@data[,input$pib] >= 1){bins <- unique(as.vector(ceiling(quantile(mapa_pib@data[,input$pib], probs = c(0,0.30,0.50,0.7,0.85,0.95,0.98,1), na.rm = T))))}else{
       bins <- unique(as.vector(quantile(mapa_pib@data[,input$pib], probs = c(0,0.20,0.50,0.7,0.85,1), na.rm = T)))}
   pal <- colorBin("YlOrRd", domain = mapa_pib@data[,input$pib], bins = bins)
   colorData <- pal(mapa_pib@data[,input$pib])
        
   labells <- sprintf(
  "<strong>%s</strong> %s <br/> %s: %s", #  people / mi<sup>2</sup>",
 'Município', mapa_pib@data$Municipio,  input$pib , mapa_pib@data[,input$pib]
) %>% lapply(htmltools::HTML)

  leafletProxy('map') %>%  clearShapes() %>%
   addPolygons(data = mapa_pib, layerId = ~Municipio, color = "#444444",
    fillColor =  colorData, stroke = T, smoothFactor = 0.5, fillOpacity = 0.3,
    weight = 1.5,highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labells,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto")) %>% 
    addLegend(pal = pal, values = colorData, opacity = 0.7, title = paste('VA', input$pib),
  position = "bottomright",
        layerId="colorLegend")# %>%
     #addMarkers(data = dado, lng = ~long, lat = ~lat )     
     })
  
 #-----------------------------------------------------------------------------#
 #---------------------Redes de Insumo-----------------------------------------#
 #-----------------------------------------------------------------------------#
  output$rede <- renderLeaflet({mapaii})
  
  produto <- reactive({insumos[insumos$produto == input$produtoii,]
          })#reactive
    
  observe({
   produtoii <- produto()  
   
   labellss <- sprintf(
  "<strong>%s</strong> %s <br/> %s: %s", #  people / mi<sup>2</sup>",
 'Município Destino:', produtoii$municipio,  'Produto:', input$produtoii
) %>% lapply(htmltools::HTML)

  labellsss <- sprintf(
  "<strong>%s</strong> %s <br/> %s: %s", #  people / mi<sup>2</sup>",
 'Município Origem:', produtoii$mun_origem,  'Produto:', input$produtoii
) %>% lapply(htmltools::HTML)

  linhaii <- lapply(1:nrow(produtoii),
         function(i){Lines(list(Line(rbindlist(list(produtoii[i,11:12],
                     produtoii[i,9:10])))), as.character(i))}) %>% SpatialLines(.)

  leafletProxy('rede') %>% clearMarkers() %>%  clearShapes() %>%
   addPolylines(data = linhaii, weight = 2, color = 'green') %>%
    addCircleMarkers(data = produtoii, lng = ~x.destino, lat = ~y.destino, weight = 5,
                       radius = 2,
                       color  = 'red', fillOpacity = 0.8,
                       label  = labellss, labelOptions = labelOptions(
                       style = list("font-weight" = "normal", padding = "3px 8px"),
                       textsize = "12px",
                       maxWidth = '200px',
                       direction = "auto")) %>%
   addCircleMarkers(data = produtoii, lng = ~x.origem, lat = ~y.origem, weight = 5,
                       radius = 2,
                       color  = 'blue', fillOpacity = 0.8,
                       label  = labellsss, labelOptions = labelOptions(
                       style = list("font-weight" = "normal", padding = "3px 8px"),
                       textsize = "12px",
                       maxWidth = '200px',
                       direction = "auto"))
     }) #observe
  

})#server