  #server para a aba salario ()
  dado <- reactive({
           if(input$comparacao_salario == 'PNADC'){
           dadoi <- pnadSC[,c(2,10:14)]}else{
           dadoi <- left_join(raisSC, pnadSC[,-c(2,10)], by = 'scn_2010', fill = 0)
           dadoi[is.na(dadoi)] <- 0
           dadoi <- dadoi[,c(2,5,13,3,15,4)]
           }
           if(isTRUE(input$checkbox)){
           dadoi <- aggregate(list(dadoi[,3:6]), by = list(dadoi$setor),  FUN = sum)
            }else{dadoi <- dadoi[,c(1,3:6)]}
          dadoi
           })
  
 output$quantidade_ocupado <- renderHigh({
                           dadoi <- dado()
                           dadoi <- dadoi[,1:3]
                           
                           unico <-  dadoi[,1]
                           dadoii <- lapply(2:3, function(y){
                                           list('name' = names(dadoi)[y],'data' = dadoi[,y])})
                                           
                           names(dadoii) <- NULL
                           list( unico, dadoii)
                           })
                           
  output$quantidade_salario <- renderHigh({
                           dadoi <- dado()
                           dadoi <- dadoi[,c(1,4:5)]
                           
                           unico <-  dadoi[,1]
                           dadoii <-   lapply(2:3, function(y){
                                           list('name' = names(dadoi)[y],'data' = dadoi[,y])})
                                                                         names(dadoii) <- NULL
                           list( unico, dadoii)
                           })
                           
                           
  output$relativo_ocupado <- renderHigh({
                           dadoi <- dado()
                           dadoi <- dadoi[,1:3]
                           dadoi[,2:3] <- sapply(dadoi[,2:3], function(x){round(x*100/apply(dadoi[,2:3],1,sum),2)})
                           unico <-  dadoi[,1]
                           dadoii <- lapply(2:3, function(y){
                                           list('name' = names(dadoi)[y],'data' = dadoi[,y])})
                                           
                           names(dadoii) <- NULL
                           list( unico, dadoii)
                           })
                           
  output$relativo_salario <- renderHigh({
                           dadoi <- dado()
                           dadoi <- dadoi[,c(1,4:5)]
                           dadoi[,2:3] <- sapply(dadoi[,2:3], function(x){round(x*100/apply(dadoi[,2:3],1,sum),2)})
                           unico <-  dadoi[,1]
                           dadoii <-   lapply(2:3, function(y){
                                           list('name' = names(dadoi)[y],'data' = dadoi[,y])})
                           names(dadoii) <- NULL
                           list( unico, dadoii)
                           })