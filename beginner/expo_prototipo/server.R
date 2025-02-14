#mapa versao 0.1


shinyServer(function(input, output, session) {
  
  #dado <- reactive({if(input$xm == 'Exportação'){dadoi <- export}else{dadoi  <- import}
  #if(input$xm == 'Importação'){dadoi <- import}
  # dadoi})
  
  
  ds2 <- reactive({if(input$xm == 'Exportação'){dados <- export}else{dados  <- import}
    #if(input$xm == 'Importação'){dadoi <- import}
    data1 <- dados[complete.cases(dados),] %>% .[.$NOME == input$municipio,]              
    if(input$pais != 'Tudo' ){data1   <- data1[data1$NO_PAIS    == input$pais,]}
    if(input$porto != 'Tudo'){data1   <- data1[data1$NO_MUN_MIN == input$porto,]}
    if(input$produto != 'Tudo'){data1 <- data1[data1$Prod.SH4 == input$produto,]}
    data1 <- data1[data1$VL_FOB >= input$fob[1] & data1$VL_FOB <= input$fob[2],]               
    data1}) 
  
  #menu interativo de pais e porto
  observe({
    hei1<-input$pais
    hei2<-input$porto
    hei3<-input$fob[1]
    hei4<-input$fob[2]
    #hei5<-input$municipio
    hei6<-input$produto
    dados<-ds2()
    
    choice1<-c('Tudo', unique((dados$NO_PAIS)))
    choice2<-c('Tudo',unique((dados$NO_MUN_MIN)))
    # choice3<-c(unique(dado$NOME))
    choice4<-c('Tudo',unique(dados$Prod.SH4))
    
    updateSelectInput(session,"pais",choices=choice1,selected=hei1)
    updateSelectInput(session,"porto",choices=choice2,selected=hei2)
    #updateSelectInput(session,"municipio",choices=choice3,selected=hei5)
    updateSelectInput(session,"produto",choices=choice4,selected=hei6)
    updateSliderInput(session,"fob",value = c(hei3,hei4), min = min(dados$VL_FOB), max = max(dados$VL_FOB))
  })
  #delimitador do tamanho das barras
  
  
  
  # ds2<- reactive({data1 <- ds()   
  #data1 <- data1[data1$VL_FOB >= input$fob[1] & data1$VL_FOB <= input$fob[2],]               
  #data1}) 
  
  #para os dados de gráfico barra
  #gráfico ranking
  dg <- reactive({data1 <- ds2()
  if(input$checkporto){graf <-  aggregate(as.numeric(KG_LIQUIDO) ~NO_MUN_MIN, data = data1, FUN = sum, na.rm= T)}else{
    graf <-  aggregate(as.numeric(VL_FOB) ~ NO_MUN_MIN, data = data1, FUN = sum, na.rm= T)}
  graf  %>% setNames(., c('Porto', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>% mutate(., Porto = Porto, Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
  })
  
  dg2 <- reactive({data1 <- ds2()
  if(input$checkpais){graf <-  aggregate(as.numeric(KG_LIQUIDO) ~ NO_PAIS, data = data1, FUN = sum, na.rm= T)}else{
    graf <-  aggregate(as.numeric(VL_FOB) ~ NO_PAIS, data = data1, FUN = sum, na.rm= T)}
  graf  %>% setNames(., c('País', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>% mutate(., País =  País, Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
  })
  
  dg3 <- reactive({data1 <- ds2()
  if(input$checkproduto){graf <-  aggregate(as.numeric(KG_LIQUIDO) ~Prod.SH4, data = data1, FUN = sum, na.rm= T)}else{
    graf <-  aggregate(as.numeric(VL_FOB) ~ Prod.SH4, data = data1, FUN = sum, na.rm= T)}
  graf %>% setNames(., c('Produto.SH2', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>% mutate(., Prod.SH2 =  paste0(substr(Produto.SH2,1,25),'(...)'), Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
  })
  
  dg4 <- reactive({data1 <- ds2()
  graf <-  aggregate(as.numeric(VL_FOB) ~ NOME, data = data1, FUN = sum, na.rm= T) %>% setNames(., c('Município', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>% mutate(., Município =  Município, Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
  graf})
  
  #dados para gráfico barras com dados mensais
  dg5 <- reactive({data1 <- ds2()
  graf <-  aggregate(as.numeric(VL_FOB) ~ CO_MES, data = data1, FUN = sum, na.rm= T) %>%
    setNames(., c('Cod_mes', 'Soma_expo')) %>%
    mutate(., Mês = as.factor(c('Jan','Fev','Mar','Abr','Maio','Jun','Jul','Ago','Set','Out','Nov','Dez')),
           Cod_mes = factor(Cod_mes))
  graf })                     
  
  #tabela resumo dos dados (26-dez-17, 17:42h)   
  dt1 <- reactive({if(input$xm == 'Exportação'){ tabprop <- export}else{ tabprop  <- import}
    if(input$produto != 'Tudo'){tabprop <- tabprop[tabprop$Prod.SH4 == input$produto,]}
    tabprop <- aggregate(as.numeric(VL_FOB) ~ NOME, data = tabprop, FUN = sum, na.rm = T) %>% 
      setNames(., c('Município', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>% 
      mutate(., Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
    tabprop <- tabprop[tabprop == input$municipio,]
    resumo <- data.frame('Variáveis' = c('Município', 'Produto SH2', '% Estado','Ranking Estado','Valor Total (US$)'),
                         'Valores'   = c(input$municipio, input$produto, tabprop[1,'Prop'],tabprop[1,'Ranking'],tabprop[1,'Soma_expo']))
    resumo  
  })                 
  
  
  output$trendPlot <- renderPlotly({
    data2 <- ds2()
    # a simple map
    mapaII <- # map_data("world","brazil") %>%
      #group_by(group)   %>%
      plot_geo() %>%
      add_markers(
        data = data2, x = ~x.orig, y = ~y.orig, text = ~NOME, color = I('red'),
        size = 10, hoverinfo = all, alpha = 0.5, name = 'Município Origem'
      ) %>%
      add_markers(
        data = data2, x = ~x.country, y = ~y.country,  
        size = ~VL_FOB,  alpha = 0.5, color = I('orange'),
        text = ~paste('Pais Destino:',NO_PAIS, '<br>Total Exportado:', VL_FOB,'<br>Porto Origem:', NO_MUN_MIN,
                      '<br>Distância Percorrida (km):', round(sum.dist,1)),
        hoverinfo = all, name = 'País Destino'
      ) %>%
      add_markers(
        data = data2, x = ~x.dest, y = ~y.dest, name = 'Município Saída', 
        text = ~NO_MUN_MIN,alpha = 0.5,  hoverinfo = all, size = 3
      ) %>%
      add_segments(
        data = data2, 
        xend = ~x.orig, x = ~x.dest,
        yend = ~y.orig, y  = ~y.dest, 
        alpha = 0.3, size = I(1), name = 'Origem>>Porto')  %>%
      add_segments(
        data = data2,  
        x = ~x.dest, xend = ~x.country,
        y = ~y.dest, yend = ~y.country, 
        alpha = 0.3, size = I(1), name = 'Porto>>País') %>%   
      layout(
        title = paste('Rede de',input$xm),
        geo = list(
          showocean = TRUE,
          showland = TRUE,
          landcolor ="#090D2A",
          countrycolor = toRGB("grey80"),
          oceancolor =  '#00001C'))
  })
  
  
  
  output$gplot   <- renderPlotly({
    theme_set(theme_minimal())
    data1 <- dg()
    graf1 <- ggplot(data1, aes(x = reorder(Porto,Soma_expo), y = Soma_expo, group = Porto)) + geom_col(aes(text = paste('Porto: ',Porto,if(input$checkporto){'<br>Volume (T):'}else{'<br>Soma_expo (US$):'}, 
                                                                                                                        Soma_expo, '<br>Proporção:', Prop,'%', '<br>Ranking: ',Ranking)),
                                                                                                       alpha = .7, fill = '#a6bddb',width = if(input$porto == 'Tudo'){NULL}else{.5})+  xlab('') + ylab('') + coord_flip() 
    
    ggplotly(graf1, tooltip = 'text') %>% layout(title = paste('Ranking dos Portos por ',input$xm),
                                                 dragmode = 'pan')})
  
  output$gplotII <- renderPlotly({                 
    theme_set(theme_minimal())
    data1 <- dg2()
    graf2 <- ggplot(data1, aes(x = reorder(País,Soma_expo), y = Soma_expo, group = País)) +
      geom_col(aes(text = paste('País: ',País,if(input$checkpais){'<br>Volume (T):'}else{'<br>Soma_expo (US$):'}, Soma_expo, '<br>Proporção:', Prop,'%', '<br>Ranking: ',Ranking)), 
               alpha = .7, fill = '#de2d26', width = if(input$pais == 'Tudo'){NULL}else{.5}) +  xlab('') + ylab('') +
      coord_flip() +  theme(axis.text.x = element_text(hjust = 1, size = 5))
    
    ggplotly(graf2, tooltip = 'text') %>% layout(title = paste0(if(input$xm == 'Exportação'){'Ranking dos países destinos das exportações'}else{'Ranking dos países de origem das importações'}))
  })
  
  output$gplotIII <- renderPlotly({                 
    theme_set(theme_minimal())
    data1 <- dg3()
    graf2 <- ggplot(data1, aes(x = reorder(Prod.SH2,Soma_expo), y = Soma_expo, group = Prod.SH2)) +
      geom_col(aes(text = paste('Produto: ',Produto.SH2,if(input$checkproduto){'<br>Volume (T):'}else{'<br>Soma_expo (US$):'},
                                Soma_expo, '<br>Proporção:', Prop,'%', '<br>Ranking: ',Ranking)), alpha = .7, fill = '#2ca25f', 
               width = if(input$produto == 'Tudo'){NULL}else{.5}) +  xlab('') + ylab('') +
      coord_flip() +  theme(axis.text.x = element_text(hjust = 1, size = 5))
    
    # %>%layout(title = 'Ranking dos produtos exportados')
    ggplotly(graf2, tooltip = 'text') %>% 
      layout(title = paste0('Ranking dos produtos (',input$xm,')'))
  })
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- ds()
    data <- data[,c(14,11,20,21,9)] %>% setNames(.,c('Origem','Porto_Origem', 'País_Destino','Produto.SH2','Soma_FOB'))
    data
  }))
  
  output$view <- renderTable({
    dt1()
  })
  
  #Gráfico Barra mensal
  output$ggplotIV <- renderPlotly({
    theme_set(theme_minimal())
    data1 <- dg5()
    graf2 <- ggplot(data1, aes(x = Cod_mes, y = Soma_expo)) + 
      geom_col(aes(text = paste('Mês: ',Mês,'<br>Soma_expo (US$):', Soma_expo)),alpha = .7, fill = '#2b8cbe')  + ylab('')  +geom_smooth(aes(y = Soma_expo, x = 1:12), method= 'lm')
    
    ggplotly(graf2) %>%layout(title = 'Valor Mensal', dragmode = 'pan')
  })
  
  # Downloadable csv of selected dataset ---- ainda a editar
  
})
