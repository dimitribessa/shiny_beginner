#análise exploratória dos dados de Presídios (01-fev-2019, 11:51h)

server <- shinyServer(function(input, output, session) {

  dado <- dados_h + dados_f
  dado <- dplyr::bind_cols(infos_pres, dado)
  names(dado)[19] <- 'populacao'

  ds <- reactive({data1 <- dado
         if(input$tipo != 'Todos' ){data1   <- data1[data1[,8]  == input$tipo,]}
         if(input$sexo != 'Todos' ){data1   <- data1[data1[,6]  == input$sexo,]}
         data1})
   
  #atribuindo o objeto mapa                    
   mapa <- leaflet() %>%
         addProviderTiles(providers$OpenStreetMap)  %>%  
       # addTiles(urlTemplate = 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_nolabels/{z}/{x}/{y}.png')  %>%
        setView(lng =  -48.5512765, lat = -27.5947736, zoom = 7) %>%
        addPolylines(data = municipiopoly_red, color = "#f5f5f5",
        weight = 2.5)  %>%
  # Layers control
  addLayersControl(overlayGroups = c("Capacidade", "População"),
    options = layersControlOptions(collapsed = F)
  )

   #renderizando os mapas (sem os dados)
   output$map     <- renderLeaflet({mapa})

   observe({

   mapai <- ds()

   if(nrow(mapai) == 0){
      return(mapa)}

    labells <- sprintf(
  "<strong>%s</strong> </br> %s: %s </br> %s %s", #  people / mi<sup>2</sup>",
  mapai[,1], 'Capacidade total relatada:', mapai[,21], 'População prisional:', mapai[,19]) %>% lapply(htmltools::HTML)


  leafletProxy('map') %>% #clearMarkers() %>%
   clearGroup('Capacidade') %>% clearGroup('População')  %>%
    addCircleMarkers(data = mapai, group = 'População',
                       lng = ~long, lat = ~lat, radius = ~populacao/100,
                       color  = 'blue', fillOpacity = 0.8,
                       label  = labells,
   labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto")) %>%
    addCircleMarkers(data = mapai, group = 'Capacidade',
                       lng = ~long, lat = ~lat, radius = ~capacidade_t/100,
                       color  = 'red', fillOpacity = 0.8,
                       label  = labells,
   labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto"))

    })#observe mapa frequência

    #-------------------------------------------------------------------------#
    #manipulando os dados de sexo, para os gráficos
    #-------------------------------------------------------------------------#    

   dado_h <- reactive({
                        data1 <- dplyr::bind_cols(infos_pres, dados_h)
                        if(input$tipo != 'Todos' ){data1   <- data1[data1[,8]  == input$tipo,]}
                        if(input$sexo != 'Todos' ){data1   <- data1[data1[,6]  == input$sexo,]}
                        data1})


    dado_f <- reactive({
                        data1 <- dplyr::bind_cols(infos_pres, dados_f)
                        if(input$tipo != 'Todos' ){data1   <- data1[data1[,8]  == input$tipo,]}
                        if(input$sexo != 'Todos' ){data1   <- data1[data1[,6]  == input$sexo,]}
                        data1})

    #-------------------------------------------------------------------------#
    #plotando os gráficos
    #-------------------------------------------------------------------------#
    output$popm <- renderbarC3({dado <- dado_h()[,c(8,22:27)]
                                dado <- sapply(split(dado, dado[,1]), function(x){sapply(x[,-1], sum, na.rm = T)}) %>%
                                        as.data.frame(.)
                                dado$.id <- row.names(dado)
                                dado})

    output$popf <- renderbarC3({dado <- dado_f()[,c(8,22:27)]
                                dado <- sapply(split(dado, dado[,1]), function(x){sapply(x[,-1], sum, na.rm = T)}) %>%
                                        as.data.frame(.)
                                dado$.id <- row.names(dado)
                                dado})

    output$capm <- renderbarC3({dado <- dado_h()[,c(8,21,12:18)]
                                names(dado) <- c('tipo','Capacidade Total','Provisório','Reg_Fechado','Reg_Semi','Reg_Aberto',                                                                  'RDD', 'Medidas de segurança de internação','Outros')
                                dado <- sapply(split(dado, dado[,1]), function(x){sapply(x[,-1], sum, na.rm = T)}) %>%
                                        as.data.frame(.)
                                dado$.id <- row.names(dado)
                                dado})

    output$capf <- renderbarC3({dado <- dado_f()[,c(8,21,12:18)]
                                names(dado) <- c('tipo','Capacidade Total','Provisório','Reg_Fechado','Reg_Semi','Reg_Aberto',                                                                  'RDD', 'Medidas de segurança de internação','Outros')
                                dado <- sapply(split(dado, dado[,1]), function(x){sapply(x[,-1], sum, na.rm = T)}) %>%
                                        as.data.frame(.)
                                dado$.id <- row.names(dado)
                                dado})
 
 }) #end