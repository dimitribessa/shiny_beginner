 #app VA mip (16-maio-21, 00:19h)
 
 shinyServer(function(input, output, session) {
  
   
   #-----------------------------------------------------------------------#
   #!abas
   #-----------------------------------------------------------------------#

   source('server_salario.R', local = T, encoding = 'UTF-8')
   
   source('server_pof.R', local = T, encoding = 'UTF-8')

  

 }) #end server function
