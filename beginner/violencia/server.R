function(input, output, session) {

  dado <- all_data
  #preparando os dados
  ds <- reactive({data1 <- dado
  if(input$idade != 'Tudo' ){data1   <- data1[data1$IDADE  == input$idade,]}
  if(input$esc != 'Tudo' ){data1   <- data1[data1$ESC    == input$esc,]}
  if(input$renda != 'Tudo'){data1 <- data1[data1$RENDA   == input$renda,]}
  if(input$cor != 'Tudo'){data1 <- data1[data1$RACACOR   == input$cor,]}
  if(input$motivo != 'Tudo'){data1 <- subset(data1, get(input$motivo) > 0)}
  if(input$agressao != 'Tudo'){data1 <- subset(data1, get(input$agressao) > 0)}
  data1})

  #para os dados da aba de percepção
  ds2 <- reactive({data1 <- dado
  data1 <- data1[data1$ANO == input$ano,]
  if(input$idade_p != 'Tudo' ){data1   <- data1[data1$IDADE  == input$idade_p,]}
  if(input$esc_p != 'Tudo' ){data1   <- data1[data1$ESC    == input$esc_p,]}
  if(input$renda_p != 'Tudo'){data1 <- data1[data1$RENDA   == input$renda_p,]}
  if(input$cor_p != 'Tudo'){data1 <- data1[data1$RACACOR   == input$cor_p,]}
  data1})
  
  #plotando os grAficos
  output$grafidade <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds()
    dado <- table(dado$ANO, dado$IDADE) %>% prop.table(., 1) %>% as.data.frame.matrix(.)
    converter(dado)
  })
  
  output$grafescola <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds()
    dado <- table(dado$ANO, dado$ESC) %>% prop.table(., 1) %>% as.data.frame.matrix(.)
    converter(dado)
  })
  
  output$grafrenda <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds()
    dado <- table(dado$ANO, dado$RENDA) %>% prop.table(., 1) %>% as.data.frame.matrix(.)
    converter(dado)
  })
  
  output$grafcor <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds()
    dado <- table(dado$ANO, dado$RACACOR) %>% prop.table(., 1) %>% as.data.frame.matrix(.)
    converter(dado)
  })
  
  #gráficos de motivo e de tipo de agressão
  
  output$grafmot <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds()
    dado <- lapply(split(dado, dado$ANO), function(x){
           sapply(x[,11:21],sum, na.rm = T)}) %>%
           plyr::ldply(.)
    
    converter(dado[,-1])
  })
  
  output$graftipo <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds()
    dado <- lapply(split(dado, dado$ANO), function(x){
           sapply(x[,22:28],sum, na.rm = T)}) %>%
           plyr::ldply(.)
    
    converter(dado[,-1])
  })

  output$tratamento <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds2()
    dado <- table(dado[,input$radio], dado$tratamento) %>% prop.table(., 1) %>% as.data.frame.matrix(.)
    converterii(dado)
  })

  output$lugar <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds2()
    dado <- table(dado[,input$radio], dado$lugar) %>% prop.table(., 1) %>% as.data.frame.matrix(.)
    converterii(dado)
  })

  output$opiniao_violencia <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds2()
    dado <- table(dado[,input$radio], dado$opiniao_violencia) %>% prop.table(., 1) %>% as.data.frame.matrix(.)
    converterii(dado)
  })

  output$denuncia <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds2()
    dado <- table(dado[,input$radio], dado$denuncia) %>% prop.table(., 1) %>% as.data.frame.matrix(.)
    converterii(dado)
  })

  output$opiniao_lei <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds2()
    dado <- table(dado[,input$radio], dado$opiniao_leis) %>% prop.table(., 1) %>% as.data.frame.matrix(.)
    converterii(dado)
  })

  output$nao_denuncia <- renderBarChart({
    # Return a data frame. Each column will be a series in the line chart.
    dado <- ds2()
    dado <- lapply(split(dado, dado[,input$radio]), function(x){
           sapply(x[,32:40],sum, na.rm = T)}) %>%
           plyr::ldply(.)
    converterii(dado[,-1])
  })
}
