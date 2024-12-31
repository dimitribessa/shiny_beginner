 #!script elaborado em 16-maio-21
 #modificado em 30-jun-21 (add pof)
 
 #tratando os dados lidos
 
 #-----------------------------------------------------------------------------
 #pnad
 raisSC$setor <- with(raisSC, ifelse(scn_2010 <= 280, 'Agropecuária',
                              ifelse(scn_2010 > 280 & scn_2010 <= 792, 'Ind. Extrativista',
                              ifelse((scn_2010 > 792 & scn_2010 <= 4180) | 
                     (scn_2010 %in% c(10911,10912,10913, 10931,10932,10933,10934,10935,27001,27002,
                     28001,28002,31801,31802)), 'Ind. Transformação', 'Serviços' ))))
                     
 names(raisSC)[3:4] <- c('ocupados_rais','massa_salario_rais')
 raisSC[,4] <- round(raisSC[,4]/10^6,2)
 
 pnadSC$setor <- with(pnadSC, ifelse(scn_2010 <= 280, 'Agropecuária',
                              ifelse(scn_2010 > 280 & scn_2010 <= 792, 'Ind. Extrativista',
                              ifelse((scn_2010 > 792 & scn_2010 <= 4180) | 
                     (scn_2010 %in% c(10911,10912,10913, 10931,10932,10933,10934,10935,27001,27002,
                     28001,28002,31801,31802)), 'Ind. Transformação', 'Serviços' )))) 
                     
 pnadSC$ocup_com_vinculo <- pnadSC[,3] + pnadSC[,5]
 pnadSC$ocup_sem_vinculo <- pnadSC[,4] + pnadSC[,6]
 pnadSC$massa_com_vinculo <- round((pnadSC[,7] + pnadSC[,9])/10^6,2)
 pnadSC$massa_sem_vinculo <- round(pnadSC[,8]/10^6,2)
 
 pnadSC[,1][pnadSC[,1] == 4680] <- 4500
 pnadSC[pnadSC[,1 == 4500],2] <- 'Comércio'
 

 #-----------------------------------------------------------------------------
 #pof
 tradutor <- arrange(tradutor, cod_scn)
 
 totais_ufs <- purrr::map_df(split(lista, lista$uf), function(x){
                total <- aggregate(DSP*PESO_FINAL ~cod_scn , data = x, FUN = sum, na.rm = T)
                #total <- tidyr::spread(total, key = cod_scn, value = `DSP * PESO_FINAL`, fill = 0)
                total <- dplyr::right_join(all.codes, total, by = 'cod_scn')
                
               }, .id = 'estado')
 names(totais_ufs)[4] <- 'Total'
                
 total_br <-  aggregate(DSP*PESO_FINAL ~cod_scn , data = lista, FUN = sum, na.rm = T) %>%
               # tidyr::spread(., key = cod_scn, value = `DSP * PESO_FINAL`, fill = 0) %>%
                dplyr::right_join(all.codes, ., by = 'cod_scn')
names(total_br)[3] <- 'Total'                
                
 produto_ufs <- purrr::map_df(split(listaKW, listaKW$uf), function(x){
                total <- aggregate(DSP*PESO_FINAL ~ KW , data = x, FUN = sum, na.rm = T)
                #total <- tidyr::spread(total, key = KW, value = `DSP * PESO_FINAL`, fill = 0)
                total <- dplyr::right_join(tradutor[,c(3,4)], total, by = c('cod_prod_1718'='KW'))
               }, .id = 'estado')
 names(produto_ufs)[4] <- 'Total'
 
                
 produto_br <-  aggregate(DSP*PESO_FINAL ~KW , data = listaKW, FUN = sum, na.rm = T) %>%
                #tidyr::spread(., key = KW, value = `DSP * PESO_FINAL`, fill = 0) %>%
                dplyr::right_join(tradutor[,c(3,4)], ., by = c('cod_prod_1718'='KW'))
  names(produto_br)[3] <- 'Total'
                
 pessoas_ufs <-  purrr::map_df(split(lista, lista$uf), function(x){
                x <- x[!duplicated(x[,1]),]
                total <- aggregate(Qtde_Pessoas*PESO_FINAL ~ renda.cat, data = x, FUN = sum, na.rm = T)
                total <- tidyr::spread(total, key = renda.cat, value = `Qtde_Pessoas * PESO_FINAL`, fill = 0)
                total }, .id = 'estado')
                
 residencias_ufs <-  purrr::map_df(split(lista, lista$uf), function(x){
                x <- x[!duplicated(x[,1]),]
                total <- aggregate(PESO_FINAL ~ renda.cat, data = x, FUN = sum, na.rm = T)
                total <- tidyr::spread(total, key = renda.cat, value = `PESO_FINAL`, fill = 0)
                total }, .id = 'estado')
 