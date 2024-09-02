 #backend leito (17-mar-2020, 09:09h)
 
 #função reativa para a obtenção dos pontos no mapa  
  info3 <- reactive({  if(input$cnes2 != 'Todos'){dadoii <- filter(dadosLEITOS2, desc_cnes == input$cnes2) %>% as.data.frame()}else{
                       dadoii <- dadosLEITOS2}
                      dadoii <- subset(dadoii, variable == input$leito)
                      dadoii <- group_by(dadoii, Codigo, Municipio, variable) %>%
                                summarise(., todos = sum(todos), sus = sum(sus), privado = sum(privado)) %>%
                                as.data.frame(.)
                      dadoii <- left_join(dadoii,municipio_point[,-c(3,5)], by = c('Codigo' = 'CD_GEOCMU'))
                      dadoii})  
                      
  info4 <- reactive({  if(input$cnes2 != 'Todos'){dadoii <- filter(dadosLEITOS2, desc_cnes == input$cnes2) %>% as.data.frame()}else{
                       dadoii <- dadosLEITOS2}
                      dadoii <- subset(dadoii, variable == input$leito)
                      dadoii <- group_by(dadoii, Codigo, Municipio, variable, NO_RAZAO_SOCIAL, NO_FANTASIA,
                                        NU_LATITUDE, NU_LONGITUDE) %>%
                                summarise(., todos = sum(todos), sus = sum(sus), privado = sum(privado)) %>%
                                as.data.frame(.)
                      dadoii})  
 
   #renderizando os mapas (sem os dados)
   output$map_leito   <- renderLeaflet({mapa %>%
                          addLayersControl(
                          baseGroups = c("Município", "Unidade Saúde"),
                          options = layersControlOptions(collapsed = F)
                          )
                         })    

 
 observe({
   if(nrow(info3()) == 0)
     return(mapa)

 labells <- sprintf(
  "<strong>%s</strong> %s<br/> %s %s<br/> %s %s<br/> %s %s", #  people / mi<sup>2</sup>",
 'Município: ', info3()$Municipio, 'Leito: ', info3()$variable, 'Quantidade Total: ', info3()$todos, 
  'SUS:',info3()$sus) %>% lapply(htmltools::HTML)
  
  labells2 <- sprintf(
  "<strong>%s</strong> %s<br/> %s %s<br/> %s %s<br/> %s %s", #  people / mi<sup>2</sup>",
 'Unidade Saúde: ', info4()$NO_FANTASIA, 'Leito: ', info4()$variable, 'Quantidade Total: ', info4()$todos, 
  'SUS:',info4()$sus) %>% lapply(htmltools::HTML)
     
   leafletProxy('map_leito')  %>% clearMarkers() %>% clearControls() %>%
    
    addCircleMarkers(data = info4(), group = 'Unidade Saúde',
              lng = ~NU_LONGITUDE, lat = ~NU_LATITUDE, weight = 5,
             radius = if(input$sus == 1){~todos}else{
                      if(input$sus == 2){~sus}else{~privado}}, 
             color  = if(input$sus == 1){'blue'}else{
                      if(input$sus == 2){'green'}else{'yellow'}}, fillOpacity = 0.8,
             label  = labells2,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto")) %>%
    
    addCircleMarkers(data = info3(), group = 'Município',
              lng = ~x, lat = ~y, weight = 5,
             radius = if(input$sus == 1){~todos}else{
                      if(input$sus == 2){~sus}else{~privado}}, 
             color  = if(input$sus == 1){'blue'}else{
                      if(input$sus == 2){'green'}else{'yellow'}}, fillOpacity = 0.8,
             label  = labells,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto")) 
   
     })

     #!values box (18-mar-2020, 16:09h)
  #equipamentos
  output$total_leitos <- renderInfoBox({
       dados <- info3()
      infoBox(
      paste("Total leitos"),
      sum(dados$todos), icon = icon("file-medical"),
      color = "blue"
    )
  })
  
  output$total_leitos_sus <- renderInfoBox({
       dados <- info3()
      infoBox(
      paste("Posse SUS"),
      sum(dados$sus),
       icon = icon("hospital"),
      color = "blue"
    )
  })

  output$total_leitos_nsus <- renderInfoBox({
       dados <- info3()
      infoBox(
      paste("Posse Privada"),
      sum(dados$privado),
       icon = icon("user-md"),
      color = "blue"
    )
  })


 #construindo a tabela equipamentos
  output$view_leito <- renderTable({
     tabela <- info3()
     if(input$sus == 1){tabela <- tabela[,c(2,4)]}
     if(input$sus == 2){tabela <- tabela[,c(2,5)]}
     if(input$sus == 3){tabela <- tabela[,c(2,6)]}
     names(tabela)[2] <- 'value'
     tabela <- tabela %>% mutate(., Percentual_Total = (value/sum(value, na.rm = T))*100) %>%
            transform(., Percentual_Total =  round(Percentual_Total,2) %>% paste0(.,'%')) %>%
            setNames(c('Municipio','Qtde Leitos','% Estado'))
  },  
                 hover = TRUE, spacing = 'xs',  
                 width = '100%')
    
  
  #construindo c3
  output$graf_leito <- renderC3({ dados <- info3()
                             dados <- dados[order(dados[,4], decreasing = T), ] %>%
                       .[,c(2,5,6)] 
                       names(dados) <- c('.id', 'Uso Sus', 'Uso Privado')
                       dados
                  }) #graf_leitos
 