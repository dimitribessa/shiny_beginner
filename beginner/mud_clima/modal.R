 #arquivo gerador de relatório
 
 observeEvent(input$modal_report,{
   showModal(
    modalDialog(easyClose = T,
     p('A configuração do sistema de cenários do 
       clima futuro, visa tornar disponíveis os estudos realizados pelo 
       Instituto Nacional de Pesquisas Espaciais (INPE) para Santa Catarina, 
       contratados no âmbito do Projeto Ampliação dos Serviços Climáticos para 
       Investimentos em infraestruturas – CSI. '),
    p('O CSI é um projeto global, desenvolvido no Brasil, Costa Rica, Vietnã e 
      países da Iniciativa da Bacia do Nilo (NBI). Financiado pelo Ministério 
      Federal do Ambiente, Proteção da Natureza e Segurança Nuclear (BMU) da 
      Alemanha e com a Cooperação Técnica Alemã GIZ 
      (Gesellschaft für Internationale Zusammenarbeit), tem como parceiros o 
      Ministério do Meio Ambiente, INPE, Estado de Santa Catarina, 
      Setores Estratégicos de Infraestrutura, Empresa de Pesquisa Energética (EPE) 
      e Agência Nacional de Transportes Aquaviários (ANTAQ).'),
   p('Em Santa Catarina, o CSI foi coordenado pela Defesa Civil do estado e 
     foi concluído em Dezembro de 2019, sendo os Cenários Climáticos um 
     produto estratégico para o estado, cujos resultados estão sendo 
     disponibilizados.'),
   p( 'No contexto do trabalho articulado com o Governo Alemão, 
      diversos estudos estratégicos estão sendo realizados para o 
      território catarinense, já estando pronto o Downscaling dos 
      cenários climáticos futuros de modelos globais para os municípios
      e territórios catarinenses, trazendo a perspectiva de estudos de 
      impactos, vulnerabilidades e potencialidades para a escala dos 
      territórios, bacias hidrográficas e nos municípios. Gerando, assim, 
      os conhecimentos valiosos sobre o futuro nos setores estratégicos e 
      vida das pessoas, que permitirão à gestão pública e privada tomarem
      medidas antecipadas de adaptação às mudanças, com 
      redução de riscos, viabilização de atividades econômicas e promoção 
      da resiliência à sociedade catarinense. ')

        ) #end modalDialog
       ) #endShowmodal
       }) #end observeEvent
 
 