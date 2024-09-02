 #backend leito (17-mar-2020, 09:09h)
 
 #função reativa para a obtenção dos pontos no mapa  
  info4 <- reactive({  if(input$cnes2 != 'Todos'){dadoii <- filter(dadosLEITOS2, desc_cnes == input$cnes2) %>% as.data.frame()}else{
                       dadoii <- dadosLEITOS2}
                      dadoii <- subset(dadoii, variable == input$leito)
                      dadoii <-group_by(dadoii, Codigo, Municipio, variable, NO_RAZAO_SOCIAL, NO_FANTASIA,
                                        NU_LATITUDE, NU_LONGITUDE) %>%
                                summarise(., todos = sum(todos), sus = sum(sus), privado = sum(privado)) %>%
                                as.data.frame(.)
                      dadoii})  
 
   #renderizando os mapas (sem os dados)
   output$map_leito   <- renderLeaflet({mapa})    

 
 observe({
   if(nrow(info4()) == 0)
     return(mapa)

 labells <- sprintf(
  "<strong>%s</strong> %s<br/> %s %s<br/> %s %s<br/> %s %s", #  people / mi<sup>2</sup>",
 'Município: ', info4()$Municipio, 'Leito: ', info4()$variable, 'Quantidade Total: ', info4()$todos, 
  'SUS:',info4()$sus) %>% lapply(htmltools::HTML)
     
   leafletProxy('map_leito')  %>% clearMarkers() %>%
    addCircleMarkers(data = info4(), lng = ~x, lat = ~y, weight = 5,
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



 #construindo a tabela equipamentos
  output$view_leito <- renderTable({
     tabela <- info4()
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
  output$graf_leito <- renderC3({ dados <- info4()
                             dados <- dados[order(dados[,4], decreasing = T), ] %>%
                       .[,c(2,5,6)] 
                       names(dados) <- c('.id', 'Uso Sus', 'Uso Privado')
                       dados
                  }) #graf_leitos
 