 #!script elaborado em 15-abr-2020
 #carregando e tratando os dados do Boa Vista
 #atualizado em 08-maio-2020 (16:09) - incorporado atualização do boa vista
 #atualizado em 01-jun-2020 (17:41h) - mudando escopo de atualização dos dados
 #atualizado em 17jun-2020 - adicionando o vetor 'rec_calc'
 #atualizado em 15-jul-2020 (2:28h) adicionado os casos ativos e a funcao de média móvel
 #-------------------#
 #em 28-jun, a maior parte das funçoe aqui desempenhadas foram transferidas para
 #o carregamento dos dados do boavista
 #em 18-mar-2, as rotinas foram repassdas para o carregamento dos dados do boa vista
 #i. carregando os dados
  #contador de municípios
 cont_mun2 <- function(x, y){dadoi <- x
                           dadoi <- dadoi[dadoi$dia <= as.Date(y), ]
                           dadoi <- dadoi[dadoi$casos >0,]
                           dadoi <- unique(dadoi$municipio)
                           length(dadoi)
                           }
 
          
 media_movel <- function(x, n = 7){stats::filter(x, rep(1 / n, n), sides = 1)}
 

 
                           

 

