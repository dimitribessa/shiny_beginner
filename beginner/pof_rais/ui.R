 #app va mipSC (16-maio-21, 00:35h)
 #atualizado em 22-jun-21, 23.22h (add dados pof)
 
 ui <-  tags$html(
         tags$head(
         HTML('<script defer src="https://use.fontawesome.com/releases/v5.15.0/js/all.js"
          integrity="sha384-slN8GvtUJGnv6ca26v8EzVaR9DC58QEwsIk9q1QXdCU8Yu8ck/tL/5szYlBbqmS+"
           crossorigin="anonymous"></script>'),
         tags$meta(charset="utf-8"),
         tags$title("Em desenvolvimento"),
         #tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css"), # href="bootstrap.min.css")
         tags$link( href="bootstrap.min.css", rel="stylesheet")
      ),  #head
     tags$body(        
  #abas para as diversas páginas
  dashboardPage(skin = 'green',
    dashboardHeader(),
     dashboardSidebar(
      sidebarMenu(id = 'menu',
       menuItem("Salários", tabName = "salario", icon = icon("hand-holding-usd")),
       menuItem("Consumo", tabName = "consumo", icon = icon("icons")),
       br(),
       conditionalPanel("input.menu === 'salario'",
        selectInput("comparacao_salario", "Comparacão:",
                  choices=  c('PNADC','PNADC - RAIS'),
                  selected = 'PNADC',
                  multiple = F),
        checkboxInput("checkbox", label = "Agregar setores?", value = F)
       ),#end conditional salario
       hr()
     
       ) #sidebarMenu
      ),#sidebar
     
     dashboardBody(
     tabItems(
     tabItem(tabName = 'salario',
       fluidRow(
         column(6,
          h3('Ocupados'),
          br(),
          h5('Quantidade absoluta'),
         barhighOutput2('quantidade_ocupado'),
          br(),
          h5('Quantidade relativa'),
          barstackedOutput('relativo_ocupado')
          ),
          
         column(6,
          h3('Salários'),
          br(),
          h5('Massa absoluta'),
          barhighOutput2('quantidade_salario'),
          br(),
          h5('Massa relativa'),
          barstackedOutput('relativo_salario')
          )  
         
          )
     
          
          ),#end tabitem salario
          
        tabItem(tabName = 'consumo',
       fluidRow(
         column(6,
          h3('Totais'),
          br(),
          h5('Brasil'),
         barhighOutput('consumo_brasil'),
          br(),
          h5('Estado'),
          selectInput("estado_consumo", "",
                  choices=  ufs[,2],
                  selected =  'Santa Catarina',
                  multiple = F),
          barhighOutput('consumo_estado'),
          h5('Comparativo'),
          p(tags$i('*percentual')),
          barhighOutput('consumo_percentual')
          #barstackedOutput('relativo_ocupado')
          ),
          
         column(6,
          h3('Produtos'),
          h5('Brasil'),
          selectInput("setor_scn_produto", "Setor SCN:",
                  choices=  all.codes[,2],
                  selected =  all.codes[1,2],
                  multiple = F),
          barhighOutput('produto_brasil'),
          br(),
          h5('Estado'),
          selectInput("estado_produto", "",
                  choices=  ufs[,2],
                  selected =  'Santa Catarina',
                  multiple = F),
          barhighOutput('produto_estado'),
          h5('Comparativo'),
          p(tags$i('*percentual')),
          barhighOutput('produto_percentual')
          #barstackedOutput('relativo_ocupado')
          )  
         
          ) #end row
     
          
          )#end tabitem consumo 
          
          )#end tabItems
          
          ) #dashboardbody
       ) #dashboardPage
   
  )#body
  ) #html
                        