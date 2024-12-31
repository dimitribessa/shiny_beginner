 #server casos 
 #atualizado em03-fev-2021 (pondo semana epid 2021)
  #modificado em 31-mar-21 (otimizando processos)
    
    #uis
    output$caso_slider <- renderUI({
    sliderInput("range", label = h3("Dia"),as.Date('2020-03-12'),
     max(data_ufs[data_ufs[,'Codigos'] == 42,1]),
      value = max(data_ufs[data_ufs[,'Codigos'] == 42,1]), step = 1, 
                  animate = FALSE)
                  })
    
   output$ui_inicial <- renderUI({ui_29mar})
   
   
  #dados a serem utilizados
  data_analise <- reactive({if(input$periodoanalise == 2){
                           dia <- seq(input$range - 7, input$range, by = 'day')}
                           if(input$periodoanalise == 3){
                           dia <- seq(input$range - 14, input$range, by = 'day') }
                           if(input$periodoanalise == 1){
                           dia <- seq(as.Date('2020-02-25'), input$range, by = 'day')}
                           #dadoi <- left_join(dadoi, pops_sc[,c(5:7)], by = 'codigo')
                           dia
                           })
   


  #qtde casos dia
    dado_casos <- reactive({data_analisei <- data_analise()
                            dadoi <- dado_estado[dado_estado$dia %in% data_analisei,]
                            dadoi$casos[is.na(dadoi$casos)] <- 0
                            dadoi$acumulado <- cumsum(dadoi[,'casos'])
                            dadoi
                  })
  
  #qtde obitos_dias dia
    dado_obitos_dias <- reactive({data_analisei <- data_analise()
                            dadoi <- dado_estado[dado_estado$dia %in% data_analisei,]
                            dadoi$obitos[is.na(dadoi$obitos)] <- 0
                            dadoi$acumulado <- cumsum(dadoi[,'obitos'], na.rm = T)
                            dadoi
                  })

  #!add em 28-maio-20 (23:59h)

                   
  #------------------------------------------------------------------------#
  #------------------------------------------------------------------------#
  #------------------------------------------------------------------------#
 #ui output (adicionado em 06-04-2020, 10:42h)
 output$qtde_municipios <- renderUI({data_analisei <- data_analise()
                          dadoi <- dado_municipio[dado_municipio$dia %in% data_analisei,]
                           dia <- unique(dadoi$municipio)
                           diff_ <- (length(dia)/295)*100
                           funcao_boxII(diff_, length(dia), 'Municípios c/ casos confirmados')
                           })


 output$novos_casos <- renderUI({
                           dadoi <- dado_estado[dado_estado$dia %in% data_analise(),]
                           novos_casos <- sum(dadoi[c((nrow(dadoi)-7):nrow(dadoi)),'casos'], na.rm = T)
                           #perc_casos <- ((dadoi[nrow(dadoi),3] - dadoi[nrow(dadoi)-1,3])*100/dadoi[nrow(dadoi)-1,3]) %>% round(2)
                           perc_casos <- (novos_casos/sum(dadoi$casos, na.rm = T))*100
                           funcao_boxII(perc_casos, novos_casos, 'Qtde. casos em 7 dias')
                           })

 #output$novos_exames <- renderUI({
  #                         dadoi <- dado_novos_exames()
   #                        novos_casos <- dadoi[nrow(dadoi),3]
    #                       perc_casos <- novos_casos - dadoi[nrow(dadoi)-1,3]
     #                      funcao_boxII(perc_casos, novos_casos, 'Exames realizados')
      #                     })
                           
                     
 
  #values box
  
   output$qtde_confirmado <- renderValueBox({data_analisei <- data_analise()
   dados <- dado_estado[dado_estado$dia %in% data_analisei,]
       dados <- sum(dados$casos, na.rm = T)
      valueBox(
      dados,
      paste("Casos confirmados (Total)"), icon = icon("procedures"),
      color = "blue"
    )
  })

  #!add em 31-mar-2020 (11:48h)
  output$obitos <- renderValueBox({data_analisei <- data_analise()
  dados <- dado_estado[dado_estado$dia %in% data_analisei,]
       dados <- sum(dados$obitos, na.rm = T)
      valueBox(
      dados,
      paste("Óbitos por COVID-19 (a partir da data do 1o sintoma)"), icon = icon("frown"),
      color = "blue"
    )
  })


 output$qtde_recuperados <- renderValueBox({data_analisei <- data_analise()
       dadoi <- dado_estado[dado_estado$dia %in% max(data_analisei),]
       dados <- dadoi$ativos
      valueBox(
      dados,
      paste("Total ativos"), icon = icon("virus"),
      color = "blue"
    )
  })
  
 #médias dia exames
 #!adicionado em 30-abr-2020

 #abaixo retirado
 #output$media_dia_exame <- renderValueBox({
  #     dados <- dado_anom()
  #     dados <- with(dados, dat_liberacao - dat_coleta)
  #     dados <- mean(dados[dados > 0], na.rm = T)
  #     dados <- round(dados, 2) %>% as.numeric
  #    valueBox(
  #    dados,
  #    paste("Média dias para liberação de pacientes"), icon = icon("file-medical"),
  #    color = "blue"
  #  )
  #})
  
  
  
  output$tx_positivo <- renderValueBox({data_analisei <- data_analise()
       dadoi <- dado_estado[dado_estado$dia %in% data_analisei,]
       
       dados <- (sum(dadoi$casos, na.rm = T)/sum(dadoi$exames, na.rm = T))*100 
       dados <- paste0(round(dados, 2),'%')
      valueBox(
      dados,
      paste("Taxa de exames positivo para COVID-19"), icon = icon("check"),
      color = "blue"
    )
  })
 

 #gráficos...
  #!add em 26-mar-2020
  #modificado em 15-jul-2020
  output$graf_sc_diario <- renderHigh({
                        req(input$range)
                        if(input$buttondiario == 1){
                        dadoi <- dado_casos()[,c('dia','acumulado')]}else{
                        dadoi <- dado_obitos_dias()[,c('dia','acumulado')]}
                        #dadoii <- media_movel(dadoi[,2]) %>% as.numeric()
                        #dadoii <- round(dadoii,2)
                        list(dadoi[,1], list(list('name' = 'Santa Catarina', 'data' = dadoi[,2],'dataLabels' = paste("enabled: true,
            rotation: -90,
            color: '#FFFFFF',
            align: 'right',
            format: '{point.y:.0f}', // one decimal
            y: 10, // 10 pixels down from the top
            style: {
                fontSize: '13px',
                fontFamily: 'Verdana, sans-serif'
            }"))
            ))
                                        
                     }) #end renderHigh
                     
  #!add em 01-abr-2020
  #dimitri - refazer o vetor de consolidação(21-set-2020, 14:57h)
  output$graf_sc_diario_novos <- renderHigh({
                        req(input$range)
                        dadoi <- dado_estado[dado_estado$dia %in% data_analise(),]
                        if(input$buttonnovos == 1){
                        dadoi <- dadoi[,c(1,3)]
                        nome <- 'Casos'}else{
                        dadoi <- dadoi[,c(1,5)]
                        nome <- 'Óbitos'}
                        
                        dadoii <- media_movel(dadoi[,2]) %>% as.numeric()
                        dadoii <- round(dadoii,2)
                        list(dadoi[,1], list(list('name' = nome, 'data' = dadoi[,2]),
                                       list('name' = 'Média Móvel', 'data' = dadoii, 'type' = 'spline', 'color' = '#000000')))
                                     

                     })

 output$municipio_chart <- renderHigh({
                           req(input$range)
                           dadoi <- dado_municipio[dado_municipio$dia %in% data_analise(),]
                           if(input$buttonmunicipio == 1){
                           dadoi <- dadoi[,c(1,2,4)]}else{
                           dadoi <- dadoi[,c(1,2,6)]}
                           names(dadoi)[3] <- 'total'
                           dadoi <- aggregate(total ~ municipio, data = dadoi, FUN = sum, na.rm = T)
                           dadoi$municipio <- as.character(dadoi$municipio)
                           names(dadoi) <- c('Município', 'Total')
                           dadoi <- arrange(dadoi, desc(Total))
                           list(dadoi[,1], list(list('data' = dadoi[,2])))
                           })
                           
 output$serie_media_exame <- renderHigh({dadoi <- dado_municipio[dado_municipio$dia %in% data_analise(),]
                         dadoi <- sapply(data_analise(), function(x){cont_mun2(dado_municipio, x)}) 
                        list('Qtde. Municípios',lapply(1:length(dadoi), function(x){list(data_analise()[x],dadoi[x])}))
                                         })

 #!add em 15-jul-2020
 #dimitri - refazer o vetor de consolidação(21-set-2020, 14:57h)
  output$graf_sc_ativo <- renderHigh({
                        req(input$range)
                        dadoi <- dado_estado[dado_estado$dia %in% data_analise(),c(1,4)]
                       

                       list(dadoi[,1], list(list('name' = 'Casos ativos', 'data' = dadoi[,2])))
                                      
                     })
 
 #modal da nota explicativa
 query_modal <- modalDialog(
    p('Os casos ativos é um indicador calculado somando-se 14 a partir da data dos sintomas iniciais, com excessões
    em caso de óbito ou em permanência alongada em UTI.'),
    p('Atenta-se também há um hiato de 9 dias para a consolidação das informações, em vista que na média leva-se de 3 a
    5 dias entre a data do sintoma inicial e a coleta do material do exame, e em seguida de 1 a 4 dias para o resultado do exame.'),
    easyClose = T,
    footer = modalButton('Fechar')
  )

  observeEvent(input$nota ,{
  showModal(query_modal)
  })

   observeEvent(input$nota2 ,{
  showModal(query_modal)
  })
 
  output$graf_sc_semana <- renderHigh({
                        req(input$range)
                        if(input$buttonsemanal == 1){
                           dadoi <- dado_estado[dado_estado$dia %in% data_analise(),c(1,3,6,7)]}else{
                           dadoi <- dado_estado[dado_estado$dia %in% data_analise(),c(1,5,6,7)]}
                       names(dadoi)[2] <- 'total'
                       dadoi <- aggregate(total ~ semana_epid + ano_epid, data = dadoi, FUN = sum, na.rm = T)
                       #dadoi <- dadoi[dadoi[,3] > 0,]
                        
                      dadoii <- lapply(split(dadoi, dadoi$ano_epid),
                                  function(x){list('name' = x[1,2], 'data' = x[,3])
                                 }) %>% unname
                       list(unique(dadoi[,1]), dadoii) %>% unname
                                       
                                      
                     })

  #.retirado estas funcinalidades (30-mar-21)
#  tab1 <- reactive({dadoi <- dado_pos()
#                  dadoi <-  dadoi[,c(110,104:105,109,57,58,62,52)]
 ##                  names(dadoi) <- c('dat_primeiros_sintomas', 'cod.ibge', 'município','regional_saude',
   #                                'ind_obito','data_obito','idade','sexo')
    #               dadoi[,1] <- as.character(dadoi[,1])
     #              dadoi[,6] <- as.character(dadoi[,6])
      #             dadoi
       #           })

  #botão download
# output$downloadTab1 <- downloadHandler(
 #   filename = function() {
#      paste('casosSC',input$range, ".csv", sep = "")
 #   },
  #  content = function(file) {
#      write.csv(tab1() , file, row.names = FALSE,  fileEncoding = 'latin1')
 #   }
 # )

  #----------------------------------------------------------------
               #mapa
   output$mapa <-  renderLeaflet({leaflet() %>%
    addTiles(urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGltaXRyaWJlc3NhIiwiYSI6ImNqOW82ZngxaTVhOW0zMm1xZGE2M2hidHoifQ.v16TlYEyqeTRXVsX-9AijQ')  %>%
        setView(lat = -27.5, lng = -51, zoom = 7) %>%
          addPolylines(data = municipiopoly, color = "#f5f5f5",
        weight = 2, opacity = 0.4)     %>%
       addLayersControl(
            baseGroups = c( "Confirmados","Óbitos", "Ativos"),
            options = layersControlOptions(collapsed = F), position = 'bottomleft' )  
        })


  observe({
   req(input$range)
   
   dadoi <- dado_municipio[dado_municipio$dia %in% data_analise(),]
   dadoi <- purrr::map_df(split(dadoi, dadoi$municipio), function(x){
          casos <- sum(x$casos, na.rm = T)
          obitos <- sum(x$obitos, na.rm = T)
          ativos <- x[nrow(x),'ativos']
          data.frame(casos, obitos, ativos)
          }, .id = 'municipio') %>%
          left_join(., pops_sc[,c(4,6)], by = c('municipio' = 'NOME DO MUNICÍPIO'))
          
    mapa <- sp::merge(municipiopoly, dadoi, by.x = 'CD_GEOCMU', by.y = 'codigo')

        labells <- sprintf(
  "<strong>%s</strong> %s<br/> %s %s<br/> %s %s<br/> %s %s ", #  people / mi<sup>2</sup>",
 'Município: ', mapa$Municipio, 'Confirmados: ', mapa$casos,
 'Óbitos: ',mapa$obitos, 'Ativos: ', mapa$ativos) %>% lapply(htmltools::HTML)


     mapa$incidencia <- mapa$casos
     paleta <- c('yellow', 'orange')
     cores <- "YlOrRd"
     titulo <- 'Confirmados'
   if(any(input$mapa_groups %in% 'Confirmados')){
     mapa$incidencia <- mapa$casos
     paleta <- c('yellow', 'orange')
     cores <- "YlOrRd"
     titulo <- 'Confirmados'}

   if(any(input$mapa_groups %in% 'Óbitos')){
     mapa$incidencia <- mapa$obitos
     paleta <- c('yellow', 'orange')
     cores <- "YlOrRd"
     titulo <- 'Óbitos'}

   if(any(input$mapa_groups %in% 'Ativos')){
     mapa$incidencia <- mapa$ativos
     paleta <- c('white', 'blue')
     cores <- 'Blues'
     titulo <- 'Ativos'}

   binsi <- unique(as.vector(round(quantile(mapa$incidencia, probs = c(0,0.30,0.50,0.65,0.8,0.95,1), na.rm = T))))
    if(length(binsi) <= 2){pali <-  colorNumeric(palette = paleta,domain = 1:2,
                na.color = "transparent")}else{
   pali <- colorBin(cores, domain =mapa$incidencia, bins = binsi,
                na.color = "transparent")}
   colorDatai <- pali(mapa$incidencia)


          leafletProxy('mapa') %>%
             clearShapes() %>%
              setView(lat = -27.5, lng = -51, zoom = 7)  %>%
               addPolygons(data = mapa,  color = "#444444",
    fillColor =  colorDatai,
     stroke = T, smoothFactor = 0.5, fillOpacity = 0.7,
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
    direction = "auto"))  %>%
    addLegend(pal = pali,  values = if(length(binsi) <= 2){unique(mapa$incidencia)}else{colorDatai},
   title = titulo, position = "bottomright",
    layerId="colorLegend2")

                   })

# output$teste <- renderPrint({input$mapa_groups})