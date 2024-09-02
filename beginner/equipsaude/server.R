#dados de unidades hospitalares (15-jul-19, 11:59h)

 server <- shinyServer(function(input, output, session) {
 
     polygon_lines <- reactive({
                      linha <- lapply(1:nrow(redes_neoplasia), 
                    function(i){Lines(list(Line(rbindlist(list(redes_neoplasia[i,25:26], redes_neoplasia[i,28:29])))), as.character(i))}) %>% SpatialLines(.)
                      linha})
                      
     polygon_lines_catarata <- reactive({
                      linha <- lapply(1:nrow(redes_catarata), 
                    function(i){Lines(list(Line(rbindlist(list(redes_catarata[i,14:15], redes_catarata[i,17:18])))), as.character(i))}) %>% SpatialLines(.)
                      linha})
                      
 #função reativa para a obtenção dos pontos no mapa  
  info <- reactive({ dadoi <- filter(dado, variable == input$equip) %>% left_join(.,municipio_point[,-c(3,5)], by = c('Codigo' = 'CD_GEOCMU'))
                     dadoi$total <- dadoi$value + dadoi$value2
                     dadoi })
  
 info2 <- reactive({  if(input$gestao == 'Todos'){dadoii <- filter(dadosCNES, Desc_CNES == input$desc )}else{
                      dadoii <- filter(dadosCNES, Desc_CNES == input$desc & VINC_SUS == input$gestao)} 
                      dadoii <- aggregate(Desc_CNES~ Codigo + Municipio + VINC_SUS, data = dadoii, FUN = length) %>% 
                      left_join(.,municipio_point[,-c(3,5)], by = c('Codigo' = 'CD_GEOCMU'))
                      dadoii})
 
 info5 <- reactive({ dadoi <- filter(dadosEQUIP, variable == input$equip) %>% as.data.frame(.)
                     dadoi$total <- dadoi$value + dadoi$value2
                     dadoi })  
                                    
  #atribuindo o objeto mapa                    
   mapa <- leaflet() %>%
         #addProviderTiles(providers$OpenStreetMap)  %>%  
        addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ', attribution = 'Maps by Secretaria de Estado do Planejamento') %>% 
        setView(lng =  -48.5512765, lat = -27.5947736, zoom = 7) %>% 
        addPolylines(data = municipiopoly, color = "#f5f5f5",
        weight = 2.5)
   
   #renderizando os mapas (sem os dados)
   output$map     <- renderLeaflet({mapa %>%
                          addLayersControl(
                          baseGroups = c("Município", "Unidade Saúde"),
                          options = layersControlOptions(collapsed = F)
                          )})
   output$mapii   <- renderLeaflet({mapa})    

 observe({proxy <-  leafletProxy('map')
         if(isTRUE(input$rede)){proxy %>%
  addPolylines(data = polygon_lines(),color = "red",
        weight = 1, group = 'b')}else{proxy %>% clearGroup('b')}
        })

 observe({proxyii <-  leafletProxy('mapii')
         if(isTRUE(input$rede2)){proxyii %>%
  addPolylines(data = polygon_lines(),color = "red",
        weight = 1, group = 'b')}else{proxyii %>% clearGroup('b')}
        })
        
  
 observe({proxyiii <-  leafletProxy('map')
         if(isTRUE(input$rede4)){proxyiii %>%
  addPolylines(data = polygon_lines_catarata(),color = "green",
        weight = 1, group = 'c')}else{proxyiii %>% clearGroup('c')}
        })

 observe({proxyiv <-  leafletProxy('mapii')
         if(isTRUE(input$rede3)){proxyiv %>%
  addPolylines(data = polygon_lines_catarata(),color = "green",
        weight = 1, group = 'c')}else{proxyiv %>% clearGroup('c')}
        })
        
 observe({
   if(nrow(info2()) == 0)
     return(mapa)

 labells <- sprintf(
  "<strong>%s</strong> %s<br/> %s %s<br/> %s %s<br/> %s %s", #  people / mi<sup>2</sup>",
 'Município: ', info()$Municipio, 'Equipamento: ', info()$variable, 'Quantidade Total: ', info()$total, 
  'Em uso (SUS): ',info()$value) %>% lapply(htmltools::HTML)
  
  labells3 <- sprintf(
  "<strong>%s</strong> %s<br/> <strong>%s</strong> %s<br/> %s %s<br/> %s %s<br/> %s %s", #  people / mi<sup>2</sup>",
 'Município: ', info5()$Municipio, 'Unidade de Saúde:', info5()$NO_FANTASIA ,
 'Equipamento: ', info5()$variable, 'Quantidade Total: ', info5()$total, 
  'Em uso (SUS): ',info5()$value) %>% lapply(htmltools::HTML)
     
   leafletProxy('map')  %>% clearMarkers() %>%
    addCircleMarkers(data = info(), group = 'Município', lng = ~x, lat = ~y, weight = 5,
             radius = if(input$sit == 1){ ~total/3.5}else{
                      if(input$sit == 2){~value/3.5}else{~value2/3.5}}, 
             color  = if(input$sit == 1){ 'blue'}else{
                      if(input$sit == 2){'green'}else{'yellow'}}, fillOpacity = 0.8,
             label  = labells,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto"))  %>%
    addCircleMarkers(data = info5(), group = 'Unidade Saúde', lng = ~NU_LONGITUDE, lat = ~NU_LATITUDE,
            weight = 5,
             radius = if(input$sit == 1){ ~total}else{
               if(input$sit == 2){~value}else{~value2}}, 
            color  = if(input$sit == 1){ 'blue'}else{
              if(input$sit == 2){'green'}else{'yellow'}}, fillOpacity = 0.8,
             label  = labells3,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto")) 
    
     labells2 <- sprintf(
  "<strong>%s</strong> %s<br/> <strong>%s</strong> <strong>%s</strong> %s", #  people / mi<sup>2</sup>",
 'Município: ', info2()$Municipio, 'Quantidade de', input$desc, info2()$Desc_CNES) %>% lapply(htmltools::HTML)
  
 leafletProxy('mapii') %>% clearMarkers() %>% addCircleMarkers(data = info2(),lng = ~x, lat = ~y, weight = 5,
             radius = ~Desc_CNES, 
             color  = if(input$gestao == 1){ 'blue'}else{'green'}, fillOpacity = 0.8,
             label  = labells2,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto")) 
     })

  #!values box (18-mar-2020, 16:09h)
  #equipamentos
  output$total_equip <- renderInfoBox({
       dados <- info()
      infoBox(
      paste("Total equipamentos"),
      sum(dados$total), icon = icon("file-medical"),
      color = "blue"
    )
  })
  
  output$total_equip_sus <- renderInfoBox({
       dados <- info()
      infoBox(
      paste("Posse SUS"),
      sum(dados$value),
       icon = icon("hospital"),
      color = "blue"
    )
  })

  output$total_equip_nsus <- renderInfoBox({
       dados <- info()
      infoBox(
      paste("Posse Privada"),
      sum(dados$vaue2),
       icon = icon("user-md"),
      color = "blue"
    )
  })


 #construindo a tabela equipamentos
  output$view <-  renderTable({ #DT::renderDataTable({
     tabela <- info()
     tabela <- tabela[,c(2,4,5)]  %>% mutate(., Percentual_Total = (value/sum(value))*100,
                                            Percentual_SUS = (value2/sum(value2))*100,
                                            Razao_SUS      = (value2/value)*100) %>%
            transform(., Percentual_Total =  round(Percentual_Total,2) %>% paste0(.,'%'),
                         Percentual_SUS =  round(Percentual_SUS,2) %>% paste0(.,'%'),
                         Razao_SUS      =  round(Razao_SUS,2) %>% paste0(.,'%')) %>%
            setNames(c('Municipio','Qtde Equipamento','Em uso (SUS)','% Total','% SUS','Razão SUS')) %>%
            .[,c(1,2,4,3,5,6)]
  },  
                 hover = TRUE, spacing = 'xs',  
                 width = '100%')

 #construindo a tabela equipamentos
  output$viewii <- renderTable({
     tabela <- info2()
     tabela <- tabela[,c(2,4)]  %>% mutate(., Percentual_Total = (Desc_CNES/sum(Desc_CNES))*100) %>%
            transform(., Percentual_Total =  round(Percentual_Total,2) %>% paste0(.,'%')) %>%
            setNames(c('Municipio','Qtde Estabelecimentos','% Estado'))
  },  
                 hover = TRUE, spacing = 'xs',  
                 width = '100%')

  
  #construindo plotly equipamentos
  output$graf1 <- renderC3({ dados <- info() %>% mutate(., dif = value - value2) 
                             dados <- dados[order(dados[,4], decreasing = T), ] %>%
                       .[,c(2,8,5)] 
                       names(dados) <- c('.id', 'Uso Sus', 'Uso Privado')
                       dados
                  }) #graf1
   
   output$grafII <- renderC3({
                     dados <- dadosCNES[dadosCNES$Desc_CNES == input$desc,] %>% 
                        aggregate(Desc_CNES ~ Municipio + VINC_SUS, data = ., FUN = length) %>%
                        mutate(., VINC_SUS = ifelse(VINC_SUS == 1, 'Vínculo SUS','Não Vinculado'))
                      dados <- tidyr::spread(dados, key = VINC_SUS, value = Desc_CNES, fill = 0)
                      names(dados)[1] <- c('.id')
                      dados
   
    }) #grafII                                                 
  
  #!Backend para leitos / municipio ((17-mar-2020, 11:00h))
  source('server_leitos.R', local = T, encoding = 'UTF-8')$value
  
  #!Backend para leitos / estabelecimento saude ((17-mar-2020, 15:00h))
 # source('server_leitos_hosp.R', local = T, encoding = 'UTF-8')$value
  
  
}) #end
