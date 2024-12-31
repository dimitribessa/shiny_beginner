 #script leitura e manipula��o de dados de Pres�dios------------------------------#


#------Carregando os pacotes necess�rios------------------------------------------#
 #.libPaths('D:\\Dimitri\\Docs 17-out-15\\R\\win-library\\3.1') #caminho dos pacotes
 library('reshape2')
 library('scales')
 library('dplyr')
 #library('TTR')
 library('data.table') #para fun��o fread()
 library('stringr') #para manipula��o de strings


 #lendo os dados
 dados <- openxlsx::read.xlsx('2016_basefinal_depen_publicacao.xlsx', sheet = 1)
 
 #filtrando as colunas necess�rias
 #somente em Santa Catarina
 dados <- dados[dados[,14] == 'SC',]
 
 #destrinchando a tabela em dados gerais do pres�dio, masculino e feminino
 infos_pres <- dados[,c(10,12:15,17:19,395)]
 
 #dados masculino
 dados_h    <- dados[,c(21:27,356,358:360,364:366,370:372,376:378,382:384,388:390,396)]
 dados_h[,3] <- as.numeric(dados_h[,3])
 
 #funcao para somar as colunas de populacao prisional
 funcao <- function(y = dados_h){
            dado <- y
           sapply(list(c(1:7),c(9:11),c(12:14),c(15:17),c(18:20),c(21:23),c(24:26)), function(x){apply(dado[,x], 1, sum, na.rm = T)}) %>%
           as.data.frame(.)  %>%
          setNames(.,c('capacidade_t','provisorio','reg_fechado','reg_semi','reg_aberto','internacao','ambulatorial'))}
          
 dados_h <- dplyr::bind_cols(dados_h[,c(1:8,27)], funcao())  
 
 #dados feminino
 dados_f    <- dados[,c(28:34,357,361:363,367:369,373:375,379:381,385:387,391:393,397)]
 dados_f[,3] <- as.numeric(dados_f[,3])
 dados_f <- dplyr::bind_cols(dados_f[,c(1:8,27)], funcao(dados_f))

 
 
 