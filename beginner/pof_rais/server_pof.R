  #server para a aba consumo (30-jun-21)
  dado_scn_estado <- reactive({
           
          dadoi <- subset(totais_ufs, estado == input$estado_consumo)
          dadoi[,-1]
           })
  
  dado_pof_brasil <- reactive({
          codigos <- tradutor[tradutor[,6] == input$setor_scn_produto,3] 
          dadoi <- subset(produto_br, cod_prod_1718 %in% codigos)
          dadoi[,-1]
           })
           
  dado_pof_estado <- reactive({
          codigos <- tradutor[tradutor[,6] == input$setor_scn_produto,3] 
          dadoi <- subset(produto_ufs, estado == input$estado_consumo & cod_prod_1718 %in% codigos)
          dadoi[,-c(1,2)]
           })
  
 output$consumo_brasil <- renderHigh({
                           dadoi <- total_br[,-1]
                           
                           
                           unico <-  dadoi[,1]
                           #dadoii <- lapply(split(dadoi, dadoi[,1]), function(y){
                            #               list('name' = y[1,1],'data' = dadoi[,2])})
                           dadoii <- dadoi[,2]                
                            names(dadoii) <- NULL
                           dadoii <- list( unico, dadoii)
                           names(dadoii) <- NULL
                           dadoii
 
                           })
                           
  output$consumo_estado <- renderHigh({
                           dadoi <- dado_scn_estado()[,-1]
                           
                           
                           unico <-  dadoi[,1]
                           #dadoii <- lapply(split(dadoi, dadoi[,1]), function(y){
                            #               list('name' = y[1,1],'data' = dadoi[,2])})
                           dadoii <- dadoi[,2]                
                            names(dadoii) <- NULL
                           dadoii <- list( unico, dadoii)
                           names(dadoii) <- NULL
                           dadoii
 
                           })
                           
  output$produto_brasil <- renderHigh({
                           dadoi <- dado_pof_brasil()
                           
                           
                           unico <-  dadoi[,1]
                           #dadoii <- lapply(split(dadoi, dadoi[,1]), function(y){
                            #               list('name' = y[1,1],'data' = dadoi[,2])})
                           dadoii <- dadoi[,2]                
                            names(dadoii) <- NULL
                           dadoii <- list( unico, dadoii)
                           names(dadoii) <- NULL
                           dadoii
 
                           })
                           
 output$produto_estado <- renderHigh({
                           dadoi <- dado_pof_estado()
                           
                           
                           unico <-  dadoi[,1]
                           #dadoii <- lapply(split(dadoi, dadoi[,1]), function(y){
                            #               list('name' = y[1,1],'data' = dadoi[,2])})
                           dadoii <- dadoi[,2]                
                            names(dadoii) <- NULL
                           dadoii <- list( unico, dadoii)
                           names(dadoii) <- NULL
                           dadoii
 
                           })
