 #app corona vírus (16-mar-20)
                  

   
 shinyServer(function(input, output, session) {
   
  
   
  # source('treating_data.R', local = T,encoding = 'UTF-8')
    
   #-----------------------------------------------------------------------#
   #!aba casos
   #-----------------------------------------------------------------------#

   source('server_casos.R', local = T, encoding = 'UTF-8')$value

  #-----------------------------------------------------------------------#
   #!aba incidências
  #-----------------------------------------------------------------------#

  #source('server_incid.R', local = T, encoding = 'UTF-8')$value

  #-----------------------------------------------------------------------#
   #!aba confirmados
  #-----------------------------------------------------------------------#

  source('server_vs.R', local = T, encoding = 'UTF-8')$value

  #-----------------------------------------------------------------------#
   #!aba território
  #-----------------------------------------------------------------------#

  source('server_regs.R', local = T, encoding = 'UTF-8')$value
  
  #-----------------------------------------------------------------------#
   #!aba série leitos
  #-----------------------------------------------------------------------#

  source('server_leitos_hist.R', local = T, encoding = 'UTF-8')$value

 }) #end server function
