 #editado para o shiny do covidSC (07-jun-2021, 12:22h)

#server <- function(input, output, session) {
  # Menu 1, Aba 1: Países - cenários após 100 casos ----
    
    observeEvent(input$country,{
        updateSelectInput(session,'highlight',
                          choices=sort(unique(input$country)))
    })
    
    observe({
        
        max_xscale <- as.numeric(Sys.Date() - as.Date("2020-02-17")) # escala móvel para o eixo x
        
        selected_countries <-  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% input$country) # recorte países
        
        paises_pessimista <- head(mortes_casos_100k %>% filter(time %in% max(time)) %>% 
                                      arrange(desc(confirm)), n = 5)$country #paises p/ cenario pessimista
        paises_otimista <- head(mortes_casos_100k %>% filter(time %in% max(time)) %>% filter(pop_100k >= 100) %>% 
                                    filter(confirm > 10000) %>% arrange(confirm), n = 5)$country #paises p/ cenario otimista
        paises_geral <- head(mortes_casos_100k %>% filter(pop_100k >= 100) %>%  filter(time %in% max(time)) %>% filter(confirm > 10000) %>%
                                 filter(!country %in% c(paises_pessimista, paises_otimista)), n = 50)$country #paises p/ cenario geral
        
        
        paises_pessimista_100k <- head(mortes_casos_100k %>% filter(pop_100k >= 100) %>% filter(time %in% max(time)) %>% 
                                           arrange(desc(cases_per_100k)), n = 5)$country #paises p/ cenario pessimista por 100k
        paises_otimista_100k <- head(mortes_casos_100k %>% filter(time %in% max(time)) %>% filter(pop_100k >= 100) %>% 
                                         filter(confirm > 10000) %>% arrange(cases_per_100k), n = 5)$country #paises p/ cenario otimista por 100k
        paises_geral_100k <- head(mortes_casos_100k %>% filter(pop_100k >= 100) %>%  filter(time %in% max(time)) %>% filter(confirm > 10000) %>%
                                      filter(!country %in% c(paises_pessimista_100k, paises_otimista_100k)), n = 50)$country #paises p/ cenario geral por 100k
        
        
        output$serie1 <- renderPlotly({
            
            plot1 <- ggplotly(ggplot(selected_countries, 
                                     aes(days_since_100_cases, confirm)) +
                                  geom_smooth(method='loess', aes(group=1), color= Tendencia_geral,
                                              data =  mortes_casos_100k %>% filter(confirm > 100) %>% 
                                                  filter(country %in% paises_geral), 
                                              linetype='dashed', size = 0.8) +
                                  geom_smooth(method='loess', aes(group=1), color = Tendencia_pessimista,  
                                              data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% paises_pessimista), 
                                              linetype='dashed', size = 0.8) +
                                  geom_smooth(method='loess', aes(group=1), color= Tendencia_otimista,
                                              data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% paises_otimista), 
                                              linetype='dashed', size = 0.8) +
                                  geom_line(mapping = aes(days_since_100_cases, confirm, color = country),  size = 0.2) + 
                                  geom_line(data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% input$highlight), size = 1,
                                            mapping = aes(x = days_since_100_cases, y = confirm), color = Brazil) +
                                  geom_point(mapping = aes(color = country), pch = 21, size = 0.5) +
                                  geom_point(data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% input$highlight), pch = 21, size = 1.3,
                                             mapping = aes(x = days_since_100_cases, y = confirm), color = Brazil) +
                                  scale_y_log10(expand = expansion(add = c(0,0.1))) +
                                  scale_x_continuous(expand = expansion(add = c(0,1)), limits = c(0, max_xscale)) +
                                  theme_minimal(base_size = 14) +
                                  theme(
                                      panel.grid.minor = element_blank(),
                                      legend.position = "none",
                                      plot.margin = margin(3,15,3,3,"mm")
                                  ) +
                                  coord_cartesian(clip = "off") +
                                  ggtitle("Países - Casos e cenários a partir do centésimo caso") +
                                  labs(x = "Dias desde o centésimo caso", y = "Total de casos confirmados (escala logarítmica)")) %>%
                config(locale = 'pt-BR')
            
            if (input$escala1 == 'Linear' && input$eixoy1 == "Casos") {
                
                plot1 <- ggplotly(ggplot(selected_countries, 
                                         aes(days_since_100_cases, confirm)) +
                                      geom_smooth(method='loess', aes(group=1), color= Tendencia_geral,
                                                  data =  mortes_casos_100k %>% filter(confirm > 100) %>% 
                                                      filter(!country %in% c(paises_pessimista, paises_otimista)), 
                                                  linetype='dashed', size = 0.8) +
                                      geom_smooth(method='loess', aes(group=1), color = Tendencia_pessimista,  
                                                  data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% paises_pessimista), 
                                                  linetype='dashed', size = 0.8) +
                                      geom_smooth(method='loess', aes(group=1), color= Tendencia_otimista,
                                                  data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% paises_otimista), 
                                                  linetype='dashed', size = 0.8) +
                                      geom_line(mapping = aes(days_since_100_cases, confirm, color = country),  size = 0.2) + 
                                      geom_line(data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% input$highlight), size = 1,
                                                mapping = aes(x = days_since_100_cases, y = confirm), color = Brazil) +
                                      geom_point(mapping = aes(color = country), pch = 21, size = 0.5) +
                                      geom_point(data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% input$highlight), pch = 21, size = 1.3,
                                                 mapping = aes(x = days_since_100_cases, y = confirm), color = Brazil) +
                                      scale_x_continuous(expand = expansion(add = c(0,1)), limits = c(0, max_xscale)) +
                                      theme_minimal(base_size = 14) +
                                      theme(
                                          panel.grid.minor = element_blank(),
                                          legend.position = "none",
                                          plot.margin = margin(3,15,3,3,"mm")
                                      ) +
                                      coord_cartesian(clip = "off") +
                                      ggtitle("Países - Casos e cenários a partir do centésimo caso") +
                                      labs(x = "Dias desde o centésimo caso", y = "Número total de casos confirmados")) %>%
                    config(locale = 'pt-BR')
                
            } # end if 
            
            else if (input$escala1 == 'Linear' && input$eixoy1 == "Casos por 100 mil habitantes") {
                
                plot1 <- ggplotly(ggplot(selected_countries, 
                                         aes(days_since_pointone_cases100k, cases_per_100k)) +
                                      geom_smooth(method='loess', aes(group=1), color= Tendencia_geral,
                                                  data =  mortes_casos_100k %>% filter(confirm > 100) %>% 
                                                      filter(!country %in% c(paises_otimista_100k, paises_pessimista_100k)), 
                                                  linetype='dashed', size = 0.8) +
                                      geom_smooth(method='loess', aes(group=1), color = Tendencia_pessimista,  
                                                  data =  mortes_casos_100k %>% filter(confirm > 100) %>% 
                                                      filter(country %in% paises_pessimista_100k), 
                                                  linetype='dashed', size = 0.8) +
                                      geom_smooth(method='loess', aes(group=1), color= Tendencia_otimista,
                                                  data =  mortes_casos_100k %>% filter(confirm > 100) %>% 
                                                      filter(country %in% paises_otimista_100k), 
                                                  linetype='dashed', size = 0.8) +
                                      geom_line(mapping = aes(days_since_pointone_cases100k, cases_per_100k, color = country),  size = 0.2) + 
                                      geom_line(data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% input$highlight), size = 1,
                                                mapping = aes(x = days_since_pointone_cases100k, y = cases_per_100k), color = Brazil) +
                                      geom_point(mapping = aes(color = country), pch = 21, size = 0.5) +
                                      geom_point(data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% input$highlight), pch = 21, size = 1.3,
                                                 mapping = aes(x = days_since_pointone_cases100k, y = cases_per_100k), color = Brazil) +
                                      scale_x_continuous(expand = expansion(add = c(0,1)), limits = c(0, max_xscale)) +
                                      theme_minimal(base_size = 14) +
                                      theme(
                                          panel.grid.minor = element_blank(),
                                          legend.position = "none",
                                          plot.margin = margin(3,15,3,3,"mm")
                                      ) +
                                      coord_cartesian(clip = "off") +
                                      ggtitle("Países - Casos por 100 mil habitantes e cenários") +
                                      labs(x = "Dias desde o 0,1 casos por 100 mil habitantes", 
                                           y = "Casos confirmados por 100 mil habitantes")) %>%
                    config(locale = 'pt-BR')
                
            } # end else if1
            
            else if (input$escala1 == 'Logarítmica' && input$eixoy1 == "Casos por 100 mil habitantes") {
                
                plot1 <- ggplotly(ggplot(selected_countries, 
                                         aes(days_since_pointone_cases100k, cases_per_100k)) +
                                      geom_smooth(method='loess', aes(group=1), color= Tendencia_geral,
                                                  data =  mortes_casos_100k %>% filter(confirm > 100) %>% 
                                                      filter(!country %in%  c(paises_otimista_100k, paises_pessimista_100k)), 
                                                  linetype='dashed', size = 0.8) +
                                      geom_smooth(method='loess', aes(group=1), color = Tendencia_pessimista,  
                                                  data =  mortes_casos_100k %>% filter(confirm > 100) %>% 
                                                      filter(country %in% paises_pessimista_100k), 
                                                  linetype='dashed', size = 0.8) +
                                      geom_smooth(method='loess', aes(group=1), color= Tendencia_otimista,
                                                  data =  mortes_casos_100k %>% filter(confirm > 100) %>% 
                                                      filter(country %in% paises_otimista_100k), 
                                                  linetype='dashed', size = 0.8) +
                                      geom_line(mapping = aes(days_since_pointone_cases100k, cases_per_100k, color = country),  size = 0.2) + 
                                      geom_line(data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% input$highlight), size = 1,
                                                mapping = aes(x = days_since_pointone_cases100k, y = cases_per_100k), color = Brazil) +
                                      geom_point(mapping = aes(color = country), pch = 21, size = 0.5) +
                                      geom_point(data =  mortes_casos_100k %>% filter(confirm > 100) %>% filter(country %in% input$highlight), pch = 21, size = 1.3,
                                                 mapping = aes(x = days_since_pointone_cases100k, y = cases_per_100k), color = Brazil) +
                                      scale_y_log10(expand = expansion(add = c(0,0.1))) +
                                      scale_x_continuous(expand = expansion(add = c(0,1)), limits = c(0, max_xscale)) +
                                      theme_minimal(base_size = 14) +
                                      theme(
                                          panel.grid.minor = element_blank(),
                                          legend.position = "none",
                                          plot.margin = margin(3,15,3,3,"mm")
                                      ) +
                                      coord_cartesian(clip = "off") +
                                      ggtitle("Países - Casos por 100 mil habitantes e cenários") +
                                      labs(x = "Dias desde o 0,1 casos por 100 mil habitantes", 
                                           y = "Casos confirmados por 100 mil habitantes")) %>%
                    config(locale = 'pt-BR')
                
            } # end else if2
            
            plot1
        })
        
        
        ## Totais Brasil e mundo
        last_data <- y %>% 
            group_by(country) %>%
            mutate(last_day_cases = cum_confirm - lag(cum_confirm)) %>%
            top_n(1, time)
        
        # Mundo:
        output$total_mundo1 <- renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"5\">", 
                        formatC(as.numeric(sum(last_data$cum_confirm)), 
                                big.mark = ".", decimal.mark = ",", format = "d"),
                        "</font></font></b>"))
        })
        
        output$total_mundo1_lastday <- renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"3\">", "+ ",
                        formatC(as.numeric(sum(last_data$last_day_cases)), 
                                big.mark = ".", decimal.mark = ",", format = "d"), 
                        "</font></font></b>",
                        "<font color=\"#000000\"><font size=\"3\">", " nas últimas 24hs", "</font></font>"))
        })
        
        
        # Brasil:
        output$total_br1 <-  renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"5\">", 
                        formatC(as.numeric(last_data[last_data$country == "Brazil", 3]$cum_confirm), 
                                big.mark = ".", decimal.mark = ",", format = "d"), 
                        "</font></font></b>"))
        })
        
        output$total_br1_lastday <-  renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"3\">", "+ ",
                        formatC(as.numeric(last_data[last_data$country == "Brazil", 4]$last_day_cases), 
                                big.mark = ".", decimal.mark = ",", format = "d"), 
                        "</font></font></b>",
                        "<font color=\"#000000\"><font size=\"3\">", " nas últimas 24hs", "</font></font>"))
        })
        
        
    })
    
    
    # Menu 1, Aba 2: Países - novos casos diários e fator de crescimento ----
    
    observe({
        
        selected_country_cases <-  growth_newcases %>% filter(country %in% input$country3)
        selected_country_deaths <-  deaths_global %>% filter(country %in% input$country3)
        
        ma_pais_casos <- sma(selected_country_cases$new_cases, order = 5) # Média móvel 5 dias
        ma_pais_deaths <- sma(selected_country_deaths$new_deaths, order = 5) # Média móvel 5 dias
        
        ma_pais_casos_7 <- sma(selected_country_cases$new_cases, order = 7) # Média móvel 7 dias
        ma_pais_deaths_7 <- sma(selected_country_deaths$new_deaths, order = 7) # Média móvel 7 dias
        
        selected_country_cases$MA5 <- ma_pais_casos$fitted
        selected_country_deaths$MA5 <- ma_pais_deaths$fitted
        
        selected_country_cases$MA7 <- ma_pais_casos_7$fitted
        selected_country_deaths$MA7 <- ma_pais_deaths_7$fitted
        
        # Novos casos
        output$serie3_1 <- renderPlotly({
            
            plot_new_cd <- ggplotly(ggplot(selected_country_cases) +
                                        geom_bar(aes(x = time, y = new_cases), stat = "identity") +
                                        scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                        geom_line(aes(x = time, y = MA5, color="Média Móvel (5 dias)"), size=0.6) +
                                        geom_line(aes(x = time, y = MA7, color="Média Móvel (7 dias)"), size=0.6) + 
                                        
                                        theme_minimal(base_size = 14) +
                                        theme(
                                            legend.position = 'top', legend.title = element_blank(),
                                            panel.grid.minor = element_blank(),
                                            plot.margin = margin(3,15,3,3,"mm"),
                                            axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                        ) +
                                        coord_cartesian(clip = "off") +
                                        ggtitle("Novos casos diários") +
                                        labs(x = "Data", y = "Número de novos casos diários")) %>%
                layout(legend = list(orientation = "h", x = 0.05, y =1)) %>%
                config(locale = 'pt-BR') 
            
            
            if (input$var4 == "Mortes") {
                
                plot_new_cd <- ggplotly(ggplot(selected_country_deaths) +
                                            geom_bar(aes(x = time, y = new_deaths), stat = "identity") +
                                            scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                            geom_line(aes(x = time, y = MA5, color="Média Móvel (5 dias)"), size=0.6) +
                                            geom_line(aes(x = time, y = MA7, color="Média Móvel (7 dias)"), size=0.6) + 
                                            
                                            theme_minimal(base_size = 14) +
                                            theme(
                                                legend.position = 'top', legend.title = element_blank(),
                                                panel.grid.minor = element_blank(),
                                                plot.margin = margin(3,15,3,3,"mm"),
                                                axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                            ) +
                                            coord_cartesian(clip = "off") +
                                            ggtitle("Novos óbitos diários") +
                                            labs(x = "Data", y = "Número de novos óbitos diários")) %>%
                    layout(legend = list(orientation = "h", x = 0.05, y =1)) %>%
                    config(locale = 'pt-BR') 
                
            }
            
            plot_new_cd
            
        }) # end renderPlotly 3_1
        
        # Fator de crescimento   
        output$serie3_2 <- renderPlotly({
            
            plot_factor <- ggplotly(ggplot(selected_country_cases) +
                                        geom_line(aes(x = time, y = growth)) +
                                        geom_line(mapping = aes(time, 1), linetype = "dotted",  size = 0.2) +
                                        scale_y_continuous(breaks = seq(1:10), limits = c(0,max(selected_country_cases$growth))) +
                                        scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                        theme_minimal(base_size = 14) +
                                        theme(
                                            panel.grid.minor = element_blank(),
                                            plot.margin = margin(3,15,3,3,"mm"),
                                            axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                        ) +
                                        coord_cartesian(clip = "off") +
                                        ggtitle("Fator de crescimento") +
                                        labs(x = "Data", y = "Fator de crescimento diário")) %>%
                config(locale = 'pt-BR')
            
            if (input$var4 == "Mortes") {
                
                plot_factor <- ggplotly(ggplot(selected_country_deaths) +
                                            geom_line(aes(x = time, y = growth_deaths)) +
                                            geom_line(mapping = aes(time, 1), linetype = "dotted",  size = 0.2) +
                                            scale_y_continuous(breaks = seq(1:10), limits = c(0,max(selected_country_deaths$growth_deaths))) +
                                            scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                            theme_minimal(base_size = 14) +
                                            theme(
                                                panel.grid.minor = element_blank(),
                                                plot.margin = margin(3,15,3,3,"mm"),
                                                axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                            ) +
                                            coord_cartesian(clip = "off") +
                                            ggtitle("Fator de crescimento dos novos óbitos") +
                                            labs(x = "Data", y = "Fator de crescimento diário")) %>%
                    config(locale = 'pt-BR')
                
            }
            
            plot_factor
            
            
        }) # end renderPlotly 3_2
        
    }) #end observe
    
    
    # Menu 1, Aba 3: Países - Taxas de letalitade ----
    observeEvent(input$country4,{
        updateSelectInput(session,'highlight4',
                          choices=sort(unique(input$country4)))
    })
    
    observe({ 
        
        selected_country4 <-  deaths_global %>% filter(country %in% input$country4)    
        
        output$serie4 <- renderPlotly({ 
            
            cfr_plot <- ggplotly(ggplot(data = selected_country4, 
                                        aes(time, cfr)) +
                                     geom_line(mapping = aes(time, cfr, color = country),  size = 0.2) + 
                                     geom_line(data =  selected_country4 %>% filter(country %in% input$highlight4), size = 1,
                                               mapping = aes(x = time, y = cfr), color = Brazil) +
                                     
                                     geom_point(aes(color = country), pch = 21, size = 0.5) +
                                     scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                     
                                     theme_minimal(base_size = 14) +
                                     theme(
                                         panel.grid.minor = element_blank(),
                                         legend.position = "none",
                                         plot.margin = margin(3,15,3,3,"mm"),
                                         axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                     ) +
                                     coord_cartesian(clip = "off") +
                                     ggtitle("Países - Taxas de letalidade") +
                                     labs(x = "Data", y = "Taxa de letalidade (%)")) %>%
                config(locale = 'pt-BR')
            
            if (input$eixo4 == 'Dias desde o primeiro caso') {
                
                cfr_plot <- ggplotly(ggplot(data = selected_country4, 
                                            aes(days_since_1, cfr)) +
                                         geom_line(mapping = aes(days_since_1, cfr, color = country),  size = 0.2) + 
                                         geom_line(data =  selected_country4 %>% filter(country %in% input$highlight4), size = 1,
                                                   mapping = aes(x = days_since_1, y = cfr), color = Brazil) +
                                         
                                         geom_point(aes(color = country), pch = 21, size = 0.5) +
                                         scale_x_continuous(expand = expansion(add = c(0,1))) +
                                         
                                         theme_minimal(base_size = 14) +
                                         theme(
                                             panel.grid.minor = element_blank(),
                                             legend.position = "none",
                                             plot.margin = margin(3,15,3,3,"mm")
                                         ) +
                                         coord_cartesian(clip = "off") +
                                         ggtitle("Países - Taxas de letalidade") +
                                         labs(x = "Dias desde o primeiro caso", y = "Taxa de letalidade (%)")) %>%
                    config(locale = 'pt-BR')
                
            } # end if
            
            cfr_plot
        }) # end renderPlotly
        
        ## CFR no Brasil e no mundo
        last_cfr <- deaths_global %>% 
            group_by(country) %>%
            top_n(1, time)
        
        # Mundo:
        output$cfr_mundo <- renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"6\">", 
                        formatC(as.numeric(last_cfr[last_cfr$country == "World", ]$cfr), 
                                big.mark = ".", decimal.mark = ",", format = "f", digits = 2),
                        "</font></font></b>"))
        })
        
        # Brasil:
        output$cfr_brasil <-  renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"6\">", 
                        formatC(as.numeric(last_cfr[last_cfr$country == "Brazil", ]$cfr), 
                                big.mark = ".", decimal.mark = ",", format = "f", digits = 2), 
                        "</font></font></b>"))
        })
        
    }) # end observe
    
    
    # Menu 1, Aba 4: Países - Mortes ----
    
    observeEvent(input$country5,{
        updateSelectInput(session,'highlight5',
                          choices=sort(unique(input$country5)))
    })
    
    observe({ 
        
        selected_country5 <-  deaths_global %>% filter(country %in% input$country5)    
        
        output$serie_mortes <- renderPlotly({ 
            
            # Mortes, escala log e x = dias desde caso 1
            deaths_plot <- ggplotly(ggplot(data = selected_country5, 
                                           aes(days_since_1, deaths)) +
                                        geom_line(mapping = aes(days_since_1, deaths, color = country),  size = 0.2) + 
                                        geom_line(data =  selected_country5 %>% filter(country %in% input$highlight5), size = 1,
                                                  mapping = aes(x = days_since_1, y = deaths), color = Brazil) +
                                        
                                        geom_point(aes(color = country), pch = 21, size = 0.5) +
                                        scale_x_continuous(expand = expansion(add = c(0,1))) +
                                        scale_y_log10(expand = expansion(add = c(0,0.1)), 
                                                      breaks = breaks_deaths, labels = breaks_deaths) +
                                        theme_minimal(base_size = 14) +
                                        theme(
                                            panel.grid.minor = element_blank(),
                                            legend.position = "none",
                                            plot.margin = margin(3,15,3,3,"mm")
                                        ) +
                                        coord_cartesian(clip = "off") +
                                        ggtitle("Países - Número de mortes") +
                                        labs(x = "Dias desde a primeira morte", y = "Número de mortes (escala logarítmica)")) %>%
                config(locale = 'pt-BR')
            
            
            # Mortes, escala linear e x = dias desde caso 1
            if (input$var_mortes_paises == 'Mortes' &&
                input$escala_mortes == 'Linear' && input$eixo_mortes == 'Dias desde o primeiro caso') {
                
                deaths_plot <- ggplotly(ggplot(data = selected_country5, 
                                               aes(days_since_1, deaths)) +
                                            geom_line(mapping = aes(days_since_1, deaths, color = country),  size = 0.2) + 
                                            geom_line(data =  selected_country5 %>% filter(country %in% input$highlight5), size = 1,
                                                      mapping = aes(x = days_since_1, y = deaths), color = Brazil) +
                                            
                                            geom_point(aes(color = country), pch = 21, size = 0.5) +
                                            scale_x_continuous(expand = expansion(add = c(0,1))) +
                                            
                                            theme_minimal(base_size = 14) +
                                            theme(
                                                panel.grid.minor = element_blank(),
                                                legend.position = "none",
                                                plot.margin = margin(3,15,3,3,"mm")
                                            ) +
                                            coord_cartesian(clip = "off") +
                                            ggtitle("Países - Número de mortes") +
                                            labs(x = "Dias desde a primeira morte", y = "Número de mortes")) %>%
                    config(locale = 'pt-BR')
                
            } # end if 1
            
            # Mortes, escala log e x = data
            else if (input$var_mortes_paises == 'Mortes' &&
                     input$escala_mortes == 'Logarítmica' && input$eixo_mortes == 'Data') {
                
                deaths_plot <- ggplotly(ggplot(data = selected_country5, 
                                               aes(time, deaths)) +
                                            geom_line(mapping = aes(time, deaths, color = country),  size = 0.2) + 
                                            geom_line(data =  selected_country5 %>% filter(country %in% input$highlight5), size = 1,
                                                      mapping = aes(x = time, y = deaths), color = Brazil) +
                                            
                                            geom_point(aes(color = country), pch = 21, size = 0.5) +
                                            scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                            scale_y_log10(expand = expansion(add = c(0,0.1)), 
                                                          breaks = breaks_deaths, labels = breaks_deaths) +
                                            
                                            theme_minimal(base_size = 14) +
                                            theme(
                                                panel.grid.minor = element_blank(),
                                                legend.position = "none",
                                                plot.margin = margin(3,15,3,3,"mm"),
                                                axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                            ) +
                                            coord_cartesian(clip = "off") +
                                            ggtitle("Países - Número de mortes") +
                                            labs(x = "Data", y = "Número de mortes")) %>%
                    config(locale = 'pt-BR') 
                
            } # end else if 1
            
            
            # Mortes, escala linear e x = data
            else if (input$var_mortes_paises == 'Mortes' &&
                     input$escala_mortes == 'Linear' && input$eixo_mortes == 'Data') {
                
                deaths_plot <- ggplotly(ggplot(data = selected_country5, 
                                               aes(time, deaths)) +
                                            geom_line(mapping = aes(time, deaths, color = country),  size = 0.2) + 
                                            geom_line(data =  selected_country5 %>% filter(country %in% input$highlight5), size = 1,
                                                      mapping = aes(x = time, y = deaths), color = Brazil) +
                                            
                                            geom_point(aes(color = country), pch = 21, size = 0.5) +
                                            scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                            
                                            theme_minimal(base_size = 14) +
                                            theme(
                                                panel.grid.minor = element_blank(),
                                                legend.position = "none",
                                                plot.margin = margin(3,15,3,3,"mm"),
                                                axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                            ) +
                                            coord_cartesian(clip = "off") +
                                            ggtitle("Países - Número de mortes") +
                                            labs(x = "Data", y = "Número de mortes")) %>%
                    config(locale = 'pt-BR') 
                
            } # end else if 2
            
            
            
            # Mortes por 100k, escala linear e x = dias desde caso 1
            else if (input$var_mortes_paises == 'Mortes por 100 mil habitantes' &&
                     input$escala_mortes == 'Linear' && input$eixo_mortes_alt == 'Dias desde 0,1 mortes por 100 mil hab.') {
                
                deaths_plot <- ggplotly(ggplot(data = selected_country5, 
                                               aes(days_since_pointone_deaths100k, deaths_100k)) +
                                            geom_line(mapping = aes(days_since_pointone_deaths100k, deaths_100k, color = country),  size = 0.2) + 
                                            geom_line(data =  selected_country5 %>% filter(country %in% input$highlight5), size = 1,
                                                      mapping = aes(x = days_since_pointone_deaths100k, y = deaths_100k), color = Brazil) +
                                            
                                            geom_point(aes(color = country), pch = 21, size = 0.5) +
                                            scale_x_continuous(expand = expansion(add = c(0,1))) +
                                            
                                            theme_minimal(base_size = 14) +
                                            theme(
                                                panel.grid.minor = element_blank(),
                                                legend.position = "none",
                                                plot.margin = margin(3,15,3,3,"mm")
                                            ) +
                                            coord_cartesian(clip = "off") +
                                            ggtitle("Países - Número de mortes por 100 mil habitantes") +
                                            labs(x = "Dias desde 0,1 mortes por 100 mil habitantes", 
                                                 y = "Mortes por 100 mil habitantes")) %>%
                    config(locale = 'pt-BR')
                
            } # end else if 3
            
            
            # Mortes 100k, escala log e x = data
            else if (input$var_mortes_paises == 'Mortes por 100 mil habitantes' &&
                     input$escala_mortes == 'Logarítmica' && input$eixo_mortes_alt == 'Data') {
                
                deaths_plot <- ggplotly(ggplot(data = selected_country5, 
                                               aes(time, deaths_100k)) +
                                            geom_line(mapping = aes(time, deaths_100k, color = country),  size = 0.2) + 
                                            geom_line(data =  selected_country5 %>% filter(country %in% input$highlight5), size = 1,
                                                      mapping = aes(x = time, y = deaths_100k), color = Brazil) +
                                            
                                            geom_point(aes(color = country), pch = 21, size = 0.5) +
                                            scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                            scale_y_log10(expand = expansion(add = c(0,0.1)), 
                                                          breaks = breaks_deaths_100k, labels = breaks_deaths_100k) +
                                            
                                            theme_minimal(base_size = 14) +
                                            theme(
                                                panel.grid.minor = element_blank(),
                                                legend.position = "none",
                                                plot.margin = margin(3,15,3,3,"mm"),
                                                axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                            ) +
                                            coord_cartesian(clip = "off") +
                                            ggtitle("Países - Número de mortes por 100 mil habitantes") +
                                            labs(x = "Data", y = "Mortes por 100 mil habitantes")) %>%
                    config(locale = 'pt-BR') 
                
            } # end else if 4
            
            # Mortes 100k, escala linear e x = data
            else if (input$var_mortes_paises == 'Mortes por 100 mil habitantes' &&
                     input$escala_mortes == 'Linear' && input$eixo_mortes_alt == 'Data') {
                
                deaths_plot <- ggplotly(ggplot(data = selected_country5, 
                                               aes(time, deaths_100k)) +
                                            geom_line(mapping = aes(time, deaths_100k, color = country),  size = 0.2) + 
                                            geom_line(data =  selected_country5 %>% filter(country %in% input$highlight5), size = 1,
                                                      mapping = aes(x = time, y = deaths_100k), color = Brazil) +
                                            
                                            geom_point(aes(color = country), pch = 21, size = 0.5) +
                                            scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                            
                                            theme_minimal(base_size = 14) +
                                            theme(
                                                panel.grid.minor = element_blank(),
                                                legend.position = "none",
                                                plot.margin = margin(3,15,3,3,"mm"),
                                                axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                            ) +
                                            coord_cartesian(clip = "off") +
                                            ggtitle("Países - Número de mortes por 100 mil habitantes") +
                                            labs(x = "Data", y = "Mortes por 100 mil habitantes")) %>%
                    config(locale = 'pt-BR') 
                
            } # end else if 5
            
            
            # Mortes 100k, escala log e x = dias
            else if (input$var_mortes_paises == 'Mortes por 100 mil habitantes' &&
                     input$escala_mortes == 'Logarítmica' && input$eixo_mortes_alt == 'Dias desde 0,1 mortes por 100 mil hab.') {
                deaths_plot <- ggplotly(ggplot(data = selected_country5, 
                                               aes(days_since_pointone_deaths100k, deaths_100k)) +
                                            geom_line(mapping = aes(days_since_pointone_deaths100k, deaths_100k, color = country),  size = 0.2) + 
                                            geom_line(data =  selected_country5 %>% filter(country %in% input$highlight5), size = 1,
                                                      mapping = aes(x = days_since_pointone_deaths100k, y = deaths_100k), color = Brazil) +
                                            
                                            geom_point(aes(color = country), pch = 21, size = 0.5) +
                                            scale_x_continuous(expand = expansion(add = c(0,1))) +
                                            scale_y_log10(limits = c(0.1, NA),
                                                          breaks = breaks_deaths_100k, labels = breaks_deaths_100k) +
                                            theme_minimal(base_size = 14) +
                                            theme(
                                                panel.grid.minor = element_blank(),
                                                legend.position = "none",
                                                plot.margin = margin(3,15,3,3,"mm")
                                            ) +
                                            coord_cartesian(clip = "off") +
                                            ggtitle("Países - Número de mortes por 100 mil habitantess") +
                                            labs(x = "Dias desde 0,1 mortes por 100 mil habitantes", 
                                                 y = "Mortes por 100 mil habitantes (escala logarítmica)")) %>%
                    config(locale = 'pt-BR')
                
            } # end else if 6
            
            deaths_plot
            
        }) # end plotly
        
        ## Totais de mortes no Brasil e no mundo
        last_data_mortes <- mortes_casos_100k %>% 
            group_by(country) %>%
            mutate(last_day_deaths = deaths - lag(deaths)) %>%
            top_n(1, time)
        
        # Mundo:
        output$total_mortes_mundo <- renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"5\">", 
                        formatC(as.numeric(sum(last_data_mortes$deaths)), 
                                big.mark = ".", decimal.mark = ",", format = "d"),
                        "</font></font></b>"))
        })
        
        output$total_mortes_mundo_lastday <- renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"3\">", "+ ", 
                        formatC(as.numeric(sum(last_data_mortes$last_day_deaths)), 
                                big.mark = ".", decimal.mark = ",", format = "d"),
                        "</font></font></b>",
                        "<font color=\"#000000\"><font size=\"3\">", " nas últimas 24hs", "</font></font>"))
        })
        
        
        
        # Brasil:
        output$total_mortes_br <-  renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"5\">", 
                        formatC(as.numeric(last_data_mortes[last_data_mortes$country == "Brazil", ]$deaths), 
                                big.mark = ".", decimal.mark = ",", format = "d"), 
                        "</font></font></b>"))
        })
        
        output$total_mortes_br_lastday <-  renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"3\">", "+ ",
                        formatC(as.numeric(last_data_mortes[last_data_mortes$country == "Brazil", ]$last_day_deaths), 
                                big.mark = ".", decimal.mark = ",", format = "d"), 
                        "</font></font></b>",
                        "<font color=\"#000000\"><font size=\"3\">", " nas últimas 24hs", "</font></font>"))
        })
        
    }) # end observe
    
    
    # Menu 2, Aba 1: Casos - UFs brasileiras ----
    
    observeEvent(input$ufs1,{
        updateSelectInput(session,'highlight_uf',
                          choices=sort(unique(input$ufs1)),
                          selected = c("Santa Catarina"),)
    })
    
    
    observe({
        
        selected_ufs <-  ufs_dia1 %>% filter(UF %in% input$ufs1)    
        
        # escala log e x = dias desde caso 1
        output$serie5 <- renderPlotly({
            
            plot_uf <- ggplotly(ggplot(data = selected_ufs, 
                                       aes(days_since_1, confirm)) +
                                    geom_line(mapping = aes(days_since_1, confirm, color = UF),  size = 0.2) + 
                                    geom_line(data = selected_ufs %>% filter(UF %in% input$highlight_uf), size = 1,
                                              mapping = aes(x = days_since_1, y = confirm), color = Brazil) +
                                    
                                    geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                    scale_x_continuous(expand = expansion(add = c(0,1))) +
                                    scale_y_log10(expand = expansion(add = c(0,0.1)), 
                                                  breaks = breaks_ufs, labels = breaks_ufs) +
                                    theme_minimal(base_size = 14) +
                                    theme(
                                        panel.grid.minor = element_blank(),
                                        legend.position = "none",
                                        plot.margin = margin(3,15,3,3,"mm")
                                    ) +
                                    coord_cartesian(clip = "off") +
                                    ggtitle("UFs - Casos a partir do primeiro dia") +
                                    labs(x = "Dias desde o primeiro caso", y = "Total de casos confirmados (escala logarítmica)")) %>%
                config(locale = 'pt-BR')
            
            # escala linear, x = dias desde caso 1, y = casos
            if (input$escala5 == 'Linear' && input$eixo5 == 'Dias desde o primeiro caso' && input$escala_casos21 == "Casos") {
                
                plot_uf <- ggplotly(ggplot(data = selected_ufs, 
                                           aes(days_since_1, confirm)) +
                                        geom_line(mapping = aes(days_since_1, confirm, color = UF),  size = 0.2) + 
                                        geom_line(data = selected_ufs %>% filter(UF %in% input$highlight_uf), size = 1,
                                                  mapping = aes(x = days_since_1, y = confirm), color = Brazil) +
                                        
                                        geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                        scale_x_continuous(expand = expansion(add = c(0,1))) +
                                        
                                        theme_minimal(base_size = 14) +
                                        theme(
                                            panel.grid.minor = element_blank(),
                                            legend.position = "none",
                                            plot.margin = margin(3,15,3,3,"mm")
                                        ) +
                                        coord_cartesian(clip = "off") +
                                        ggtitle("UFs - Casos a partir do primeiro dia") +
                                        labs(x = "Dias desde o primeiro caso", y = "Total de casos confirmados")) %>%
                    config(locale = 'pt-BR')
                
            } #end if1
            
            # escala log, x = data, y = casos
            else if (input$escala5 == 'Logarítmica' && input$eixo5 == 'Data' && input$escala_casos21 == "Casos") {
                
                plot_uf <- ggplotly(ggplot(data = selected_ufs, 
                                           aes(date, confirm)) +
                                        geom_line(mapping = aes(date, confirm, color = UF),  size = 0.2) + 
                                        geom_line(data = selected_ufs %>% filter(UF %in% input$highlight_uf), size = 1,
                                                  mapping = aes(x = date, y = confirm), color = Brazil) +
                                        
                                        geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                        scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                        scale_y_log10(expand = expansion(add = c(0,0.1)), 
                                                      breaks = breaks_ufs, labels = breaks_ufs) +
                                        theme_minimal(base_size = 14) +
                                        theme(
                                            panel.grid.minor = element_blank(),
                                            legend.position = "none",
                                            plot.margin = margin(3,15,3,3,"mm"),
                                            axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                        ) +
                                        coord_cartesian(clip = "off") +
                                        ggtitle("UFs - Casos a partir do primeiro dia") +
                                        labs(x = "Data", y = "Total de casos confirmados (escala logarítmica)")) %>%
                    config(locale = 'pt-BR')
                
            } # end else if 1
            
            # escala linear, x = data, y = casos
            else if (input$escala5 == 'Linear' && input$eixo5 == 'Data' && input$escala_casos21 == "Casos") {
                
                plot_uf <- ggplotly(ggplot(data = selected_ufs, 
                                           aes(date, confirm)) +
                                        geom_line(mapping = aes(date, confirm, color = UF),  size = 0.2) + 
                                        geom_line(data = selected_ufs %>% filter(UF %in% input$highlight_uf), size = 1,
                                                  mapping = aes(x = date, y = confirm), color = Brazil) +
                                        
                                        geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                        scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                        
                                        theme_minimal(base_size = 14) +
                                        theme(
                                            panel.grid.minor = element_blank(),
                                            legend.position = "none",
                                            plot.margin = margin(3,15,3,3,"mm"),
                                            axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                        ) +
                                        coord_cartesian(clip = "off") +
                                        ggtitle("UFs - Casos a partir do primeiro dia") +
                                        labs(x = "Data", y = "Total de casos confirmados")) %>%
                    config(locale = 'pt-BR')
            } # end else if 2
            
            # escala linear, x = dias desde caso 1, y = casos por 100 mil
            else if (input$escala5 == 'Linear' && input$eixo5_alt == 'Dias desde 0,1 casos por 100 mil hab.' && 
                     input$escala_casos21 == "Casos por 100 mil habitantes") {
                
                plot_uf <- ggplotly(ggplot(data = selected_ufs, 
                                           aes(days_since_pointone_cases100k, cases_per_100k)) +
                                        geom_line(mapping = aes(days_since_pointone_cases100k, cases_per_100k, color = UF),  size = 0.2) + 
                                        geom_line(data = selected_ufs %>% filter(UF %in% input$highlight_uf), size = 1,
                                                  mapping = aes(x = days_since_pointone_cases100k, y = cases_per_100k), color = Brazil) +
                                        
                                        geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                        scale_x_continuous(expand = expansion(add = c(0,1))) +
                                        
                                        theme_minimal(base_size = 14) +
                                        theme(
                                            panel.grid.minor = element_blank(),
                                            legend.position = "none",
                                            plot.margin = margin(3,15,3,3,"mm")
                                        ) +
                                        coord_cartesian(clip = "off") +
                                        ggtitle("UFs - Casos por 100 mil habitantes") +
                                        labs(x = "Dias desde 0,1 casos por 100 mil habitantes", 
                                             y = "Casos por 100 mil habitantes")) %>%
                    config(locale = 'pt-BR')
                
            } #end else if 3
            
            # escala log, x = data, y = casos por 100 mil
            else if (input$escala5 == 'Logarítmica' && input$eixo5_alt == 'Data' 
                     && input$escala_casos21 == "Casos por 100 mil habitantes") {
                
                plot_uf <- ggplotly(ggplot(data = selected_ufs, 
                                           aes(date, cases_per_100k)) +
                                        geom_line(mapping = aes(date, cases_per_100k, color = UF),  size = 0.2) + 
                                        geom_line(data = selected_ufs %>% filter(UF %in% input$highlight_uf), size = 1,
                                                  mapping = aes(x = date, y = cases_per_100k), color = Brazil) +
                                        
                                        geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                        scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                        scale_y_log10(expand = expansion(add = c(0,0.1)), 
                                                      breaks = breaks_ufs4, labels = breaks_ufs4) +
                                        theme_minimal(base_size = 14) +
                                        theme(
                                            panel.grid.minor = element_blank(),
                                            legend.position = "none",
                                            plot.margin = margin(3,15,3,3,"mm"),
                                            axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                        ) +
                                        coord_cartesian(clip = "off") +
                                        ggtitle("UFs - Casos por 100 mil habitantes") +
                                        labs(x = "Data", y = "Casos por 100 mil habitantes (escala logarítmica)")) %>%
                    config(locale = 'pt-BR')
                
            } # end else if 4
            
            # escala linear, x = data, y = casos por 100 mil
            else if (input$escala5 == 'Linear' && input$eixo5_alt == 'Data' && input$escala_casos21 == "Casos por 100 mil habitantes") {
                
                plot_uf <- ggplotly(ggplot(data = selected_ufs, 
                                           aes(date, cases_per_100k)) +
                                        geom_line(mapping = aes(date, cases_per_100k, color = UF),  size = 0.2) + 
                                        geom_line(data = selected_ufs %>% filter(UF %in% input$highlight_uf), size = 1,
                                                  mapping = aes(x = date, y = cases_per_100k), color = Brazil) +
                                        
                                        geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                        scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                        
                                        theme_minimal(base_size = 14) +
                                        theme(
                                            panel.grid.minor = element_blank(),
                                            legend.position = "none",
                                            plot.margin = margin(3,15,3,3,"mm"),
                                            axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                        ) +
                                        coord_cartesian(clip = "off") +
                                        ggtitle("UFs - Casos por 100 mil habitantes") +
                                        labs(x = "Data", y = "Casos por 100 mil habitantes")) %>%
                    config(locale = 'pt-BR')
            } # end else if 4
            
            
            
            # escala logarítmica, x = dias desde caso 1, y = casos por 100 mil
            else if (input$escala5 == 'Logarítmica' && input$eixo5_alt == 'Dias desde 0,1 casos por 100 mil hab.' && input$escala_casos21 == "Casos por 100 mil habitantes") {
                
                plot_uf <- ggplotly(ggplot(data = selected_ufs, 
                                           aes(days_since_pointone_cases100k, cases_per_100k)) +
                                        geom_line(mapping = aes(days_since_pointone_cases100k, cases_per_100k, color = UF),  size = 0.2) + 
                                        geom_line(data = selected_ufs %>% filter(UF %in% input$highlight_uf), size = 1,
                                                  mapping = aes(x = days_since_pointone_cases100k, y = cases_per_100k), color = Brazil) +
                                        
                                        geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                        scale_x_continuous(expand = expansion(add = c(0,1))) +
                                        scale_y_log10(limits = c(0.1, NA), 
                                                      breaks = breaks_ufs4, labels = breaks_ufs4) +
                                        
                                        theme_minimal(base_size = 14) +
                                        theme(
                                            panel.grid.minor = element_blank(),
                                            legend.position = "none",
                                            plot.margin = margin(3,15,3,3,"mm")
                                        ) +
                                        coord_cartesian(clip = "off") +
                                        ggtitle("UFs - Casos por 100 mil habitantes") +
                                        labs(x = "Dias desde 0,1 casos por 100 mil habitantes", 
                                             y = "Casos por 100 mil habitantes (escala logarítmica)")) %>%
                    config(locale = 'pt-BR')
                
            } #end else if 5
            
            plot_uf
        })
        
        ## Casos Brasil e UF selecionada
        
        ## Totais Brasil e mundo
        casos_brasil_last <- y %>% 
            group_by(country) %>%
            top_n(1, time)
        
        casos_last_values <- ufs_dia1 %>%
            group_by(UF) %>%
            top_n(1, date)
        
        # Brasil
        output$total_casos_br <-  renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"6\">", 
                        formatC(as.numeric(casos_brasil_last[casos_brasil_last$country == "Brazil", 3]$cum_confirm), 
                                big.mark = ".", decimal.mark = ",", format = "d"), 
                        "</font></font></b>"))
        })
        
        # UF:
        output$UF_casos_total <- renderText({
            HTML(paste0("<b>", "Em ", input$highlight_uf, ":", "</b>")) })
        
        
        output$total_casos_uf <-  renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"6\">", 
                        formatC(as.numeric(casos_last_values[casos_last_values$UF == c(input$highlight_uf), ]$confirm), 
                                big.mark = ".", decimal.mark = ",", format = "d"), 
                        "</font></font></b>"))
        })
        
        
    })
    
    
    ## Menu 2, Aba 2: UFs - Fator de crescimento e participação no total ----
    observeEvent(input$ufs2,{
        updateSelectInput(session,'highlight_uf2',
                          choices=sort(unique(input$ufs2)),
                          selected = c("Santa Catarina"),)
    })
    
    observe({
        
        selected_ufs2 <-  growth_share %>% filter(UF %in% input$ufs2)     
        
        output$serie6 <- renderPlotly({
            
            plot_share_growth <- ggplotly(ggplot(data = selected_ufs2, 
                                                 aes(date, growth)) +
                                              geom_line(mapping = aes(date, growth, color = UF),  size = 0.2) + 
                                              geom_line(mapping = aes(date, 1), linetype = "dotted",  size = 0.2) +
                                              geom_line(data = selected_ufs2 %>% filter(UF %in% input$highlight_uf2), size = 1,
                                                        mapping = aes(x = date, y = growth), color = Brazil) +
                                              
                                              geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                              scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                              scale_y_continuous(breaks = seq(1:10), limits = c(0,10)) +
                                              theme_minimal(base_size = 14) +
                                              theme(
                                                  panel.grid.minor = element_blank(),
                                                  legend.position = "none",
                                                  plot.margin = margin(3,15,3,3,"mm"),
                                                  axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                              ) +
                                              coord_cartesian(clip = "off") +
                                              ggtitle("UFs - Fatores de crescimento") +
                                              labs(x = "Data", y = "Fator de crescimento") 
            ) %>%
                config(locale = 'pt-BR')
            
            
            if (input$tipo_uf == 'Participação no total de casos') {
                
                plot_share_growth <- ggplotly(ggplot(data = selected_ufs2, 
                                                     aes(date, share)) +
                                                  geom_line(mapping = aes(date, share, color = UF),  size = 0.2) + 
                                                  geom_line(data = selected_ufs2 %>% filter(UF %in% input$highlight_uf2), size = 1,
                                                            mapping = aes(x = date, y = share), color = Brazil) +
                                                  
                                                  geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                                  scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                                  theme_minimal(base_size = 14) +
                                                  theme(
                                                      panel.grid.minor = element_blank(),
                                                      legend.position = "none",
                                                      plot.margin = margin(3,15,3,3,"mm"),
                                                      axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                                  ) +
                                                  coord_cartesian(clip = "off") +
                                                  ggtitle("UFs - Proporção do total de casos") +
                                                  labs(x = "Data", y = "Participação no total de casos (%)") 
                ) %>%
                    config(locale = 'pt-BR')
            } # end if
            plot_share_growth
        })
    })
    
    
    ## Menu 2, Aba 3: UFs - Taxas de letalidade ----
    observeEvent(input$ufs4,{
        updateSelectInput(session,'highlight_uf4',
                          choices=sort(unique(input$ufs4)),
                          selected = c("Santa Catarina"),)
    })
    
    observe({
        
        selected_ufs4 <-  deaths_uf %>% filter(UF %in% input$ufs4)
        
        output$serie_cfr_ufs <- renderPlotly({ 
            
            # desde o dia 1 
            cfr_ufs <- ggplotly(ggplot(data = selected_ufs4, 
                                       aes(days_since_1, cfr)) +
                                    geom_line(mapping = aes(days_since_1, cfr, color = UF),  size = 0.2) + 
                                    geom_line(data = selected_ufs4 %>% filter(UF %in% input$highlight_uf4), size = 1,
                                              mapping = aes(x = days_since_1, y = cfr), color = Brazil) +
                                    
                                    geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                    
                                    theme_minimal(base_size = 14) +
                                    theme(
                                        panel.grid.minor = element_blank(),
                                        legend.position = "none",
                                        plot.margin = margin(3,15,3,3,"mm")
                                    ) +
                                    coord_cartesian(clip = "off") +
                                    ggtitle("UFs - Taxas de letalidade") + 
                                    labs(x = "Dias desde o primeiro caso", y = "Taxa de letalidade (%)")) %>%
                config(locale = 'pt-BR')
            
            # datas
            if (input$eixo_cfr_ufs == 'Data') {
                cfr_ufs <- ggplotly(ggplot(data = selected_ufs4, 
                                           aes(date, cfr)) +
                                        geom_line(mapping = aes(date, cfr, color = UF),  size = 0.2) + 
                                        geom_line(data = selected_ufs4 %>% filter(UF %in% input$highlight_uf4), size = 1,
                                                  mapping = aes(x = date, y = cfr), color = Brazil) +
                                        
                                        geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                        scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                        theme_minimal(base_size = 14) +
                                        theme(
                                            panel.grid.minor = element_blank(),
                                            legend.position = "none",
                                            plot.margin = margin(3,15,3,3,"mm"),
                                            axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                        ) +
                                        coord_cartesian(clip = "off") +
                                        ggtitle("UFs - Taxas de letalidade") + 
                                        labs(x = "Dias desde o primeiro caso", y = "Taxa de letalidade (%)")) %>%
                    config(locale = 'pt-BR')
            } # end if
            
            cfr_ufs
            
        }) # end renderPlotly
        
        
        ## CFR Brasil e UF selecionada
        cfr_last <- deaths_uf %>%
            group_by(UF) %>%
            top_n(1, date)
        
        # Brasil
        output$cfr_br <- renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"6\">", 
                        formatC(as.numeric(cfr_last[cfr_last$UF == "Brasil", ]$cfr), 
                                big.mark = ".", decimal.mark = ",", format = "f", digits = 2),
                        "</font></font></b>"))
        })
        
        # UF:
        output$UF_cfr <- renderText({
            HTML(paste0("<b>", "Em ", input$highlight_uf4, ":", "</b>")) })
        
        
        output$cfr_uf <-  renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"6\">", 
                        formatC(as.numeric(cfr_last[cfr_last$UF == c(input$highlight_uf4), ]$cfr), 
                                big.mark = ".", decimal.mark = ",", format = "f", digits = 2), 
                        "</font></font></b>"))
        })
        
        
        
    }) # end observe
    
    
    
    ## Menu 2, Aba 4: UFs - Mortes ----
    observeEvent(input$ufs5,{
        updateSelectInput(session,'highlight_uf5',
                          choices=sort(unique(input$ufs5)),
                          selected = c("Santa Catarina"),)
    })
    
    observe({
        
        selected_ufs5 <-  deaths_uf %>% filter(UF %in% input$ufs5)     
        
        output$serie_mortes_ufs <- renderPlotly({ 
            
            # escala linear e x = data
            mortes_ufs <- ggplotly(ggplot(data = selected_ufs5, 
                                          aes(date, deaths)) +
                                       geom_line(mapping = aes(date, deaths, color = UF),  size = 0.2) + 
                                       geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                       geom_line(data = selected_ufs5 %>% filter(UF %in% input$highlight_uf5), size = 1,
                                                 mapping = aes(x = date, y = deaths), color = Brazil) +
                                       
                                       scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                       
                                       theme_minimal(base_size = 14) +
                                       theme(
                                           panel.grid.minor = element_blank(),
                                           legend.position = "none",
                                           plot.margin = margin(3,15,3,3,"mm"),
                                           axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                       ) +
                                       coord_cartesian(clip = "off") +
                                       ggtitle("UFs - Número de mortes") +
                                       labs(x = "Data", y = "Número de mortes")) %>%
                config(locale = 'pt-BR')
            
            
            
            # escala linear e x = dias desde caso 1
            if (input$var_morte == "Mortes" &&
                input$escala_mortes_ufs == 'Linear' && input$eixo_mortes_ufs == 'Dias desde a primeira morte') {
                
                mortes_ufs <- ggplotly(ggplot(data = selected_ufs5, 
                                              aes(days_since_1, deaths)) +
                                           geom_line(mapping = aes(days_since_1, deaths, color = UF),  size = 0.2) + 
                                           geom_line(data = selected_ufs5 %>% filter(UF %in% input$highlight_uf5), size = 1,
                                                     mapping = aes(x = days_since_1, y = deaths), color = Brazil) +
                                           
                                           geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                           
                                           theme_minimal(base_size = 14) +
                                           theme(
                                               panel.grid.minor = element_blank(),
                                               legend.position = "none",
                                               plot.margin = margin(3,15,3,3,"mm")
                                           ) +
                                           coord_cartesian(clip = "off") +
                                           ggtitle("UFs - Número de mortes") +
                                           labs(x = "Dias desde a primeira morte", y = "Número de mortes")) %>%
                    config(locale = 'pt-BR')
                
            } # end if 1
            
            # escala log e x = data
            else if (input$var_morte == "Mortes" &&
                     input$escala_mortes_ufs == 'Logarítmica' && input$eixo_mortes_ufs == 'Data') {
                mortes_ufs <- ggplotly(ggplot(data = selected_ufs5, 
                                              aes(date, deaths)) +
                                           geom_line(mapping = aes(date, deaths, color = UF),  size = 0.2) + 
                                           geom_line(data = selected_ufs5 %>% filter(UF %in% input$highlight_uf5), size = 1,
                                                     mapping = aes(x = date, y = deaths), color = Brazil) +
                                           
                                           geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                           scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                           scale_y_log10(expand = expansion(add = c(0,0.1)), 
                                                         breaks = breaks_deaths, labels = breaks_deaths) +
                                           theme_minimal(base_size = 14) +
                                           theme(
                                               panel.grid.minor = element_blank(),
                                               legend.position = "none",
                                               plot.margin = margin(3,15,3,3,"mm"),
                                               axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                           ) +
                                           coord_cartesian(clip = "off") +
                                           ggtitle("UFs - Número de mortes") +
                                           labs(x = "Data", y = "Número de mortes (escala logarítmica)")) %>%
                    config(locale = 'pt-BR')
            } # end else if 1
            
            # escala log e x = dias desde caso 1
            else if (input$var_morte == "Mortes" &&
                     input$escala_mortes_ufs == 'Logarítmica' && input$eixo_mortes_ufs == 'Dias desde a primeira morte') {
                
                mortes_ufs <- ggplotly(ggplot(data = selected_ufs5, 
                                              aes(days_since_1, deaths)) +
                                           geom_line(mapping = aes(days_since_1, deaths, color = UF),  size = 0.2) + 
                                           geom_line(data = selected_ufs5 %>% filter(UF %in% input$highlight_uf5), size = 1,
                                                     mapping = aes(x = days_since_1, y = deaths), color = Brazil) +
                                           geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                           scale_y_log10(expand = expansion(add = c(0,0.1)), 
                                                         breaks = breaks_deaths, labels = breaks_deaths) +
                                           
                                           theme_minimal(base_size = 14) +
                                           theme(
                                               panel.grid.minor = element_blank(),
                                               legend.position = "none",
                                               plot.margin = margin(3,15,3,3,"mm")
                                           ) +
                                           coord_cartesian(clip = "off") +
                                           ggtitle("UFs - Número de mortes") +
                                           labs(x = "Dias desde a primeira morte", y = "Número de mortes (escala logarítmica)")) %>%
                    config(locale = 'pt-BR')     
            } # end else if 2
            
            # Escala linear, x = data, y = mortes 100k
            else if (input$var_morte == "Mortes por 100 mil habitantes" &&
                     input$escala_mortes_ufs == 'Linear' &&
                     input$eixo_mortes_ufs_alt == 'Data') {
                
                mortes_ufs <- ggplotly(ggplot(data = selected_ufs5, 
                                              aes(date, mortes_100k)) +
                                           geom_line(mapping = aes(date, mortes_100k, color = UF),  size = 0.2) + 
                                           geom_line(data = selected_ufs5 %>% filter(UF %in% input$highlight_uf5), size = 1,
                                                     mapping = aes(x = date, y = mortes_100k), color = Brazil) +
                                           geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                           scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                           
                                           theme_minimal(base_size = 14) +
                                           theme(
                                               panel.grid.minor = element_blank(),
                                               legend.position = "none",
                                               plot.margin = margin(3,15,3,3,"mm"),
                                               axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                           ) +
                                           coord_cartesian(clip = "off") +
                                           ggtitle("UFs - Mortes por 100 mil habitantes") +
                                           labs(x = "Data", y = "Mortes por 100 mil habitantes")) %>%
                    config(locale = 'pt-BR')
            } # end else if 3
            
            # Escala linear, x = dias, y = mortes 100k
            else if (input$var_morte == "Mortes por 100 mil habitantes" &&
                     input$escala_mortes_ufs == 'Linear' &&
                     input$eixo_mortes_ufs_alt == 'Dias desde 0,1 mortes por 100 mil hab.') {
                
                mortes_ufs <- ggplotly(ggplot(data = selected_ufs5 , 
                                              aes(days_since_pointone_deaths100k, mortes_100k)) +
                                           geom_line(mapping = aes(days_since_pointone_deaths100k, mortes_100k, color = UF),  size = 0.2) + 
                                           geom_line(data = selected_ufs5 %>% filter(UF %in% input$highlight_uf5), size = 1,
                                                     mapping = aes(x = days_since_pointone_deaths100k, y = mortes_100k), color = Brazil) +
                                           geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                           
                                           theme_minimal(base_size = 14) +
                                           theme(
                                               panel.grid.minor = element_blank(),
                                               legend.position = "none",
                                               plot.margin = margin(3,15,3,3,"mm")
                                           ) +
                                           coord_cartesian(clip = "off") +
                                           ggtitle("UFs - Mortes por 100 mil habitantes") +
                                           labs(x = "Dias desde 0,1 mortes por 100 mil habitantes", 
                                                y = "Mortes por 100 mil habitantes")) %>%
                    config(locale = 'pt-BR')
            } # end else if 4
            
            
            
            # Escala log, x = data, y = mortes 100k
            else if (input$var_morte == "Mortes por 100 mil habitantes" &&
                     input$escala_mortes_ufs == 'Logarítmica' &&
                     input$eixo_mortes_ufs_alt == 'Data') {
                
                mortes_ufs <- ggplotly(ggplot(data = selected_ufs5, 
                                              aes(date, mortes_100k)) +
                                           geom_line(mapping = aes(date, mortes_100k, color = UF),  size = 0.2) + 
                                           geom_line(data = selected_ufs5 %>% filter(UF %in% input$highlight_uf5), size = 1,
                                                     mapping = aes(x = date, y = mortes_100k), color = Brazil) +
                                           geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                           scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                           scale_y_log10(limits = c(0.1, NA), 
                                                         breaks = breaks_ufs4, labels = breaks_ufs4) +
                                           
                                           theme_minimal(base_size = 14) +
                                           theme(
                                               panel.grid.minor = element_blank(),
                                               legend.position = "none",
                                               plot.margin = margin(3,15,3,3,"mm"),
                                               axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                           ) +
                                           coord_cartesian(clip = "off") +
                                           ggtitle("UFs - Mortes por 100 mil habitantes") +
                                           labs(x = "Data", y = "Mortes por 100 mil habitantes")) %>%
                    config(locale = 'pt-BR')
            } # end else if 5
            
            # Escala log, x = dias, y = mortes 100k
            else if (input$var_morte == "Mortes por 100 mil habitantes" &&
                     input$escala_mortes_ufs == 'Logarítmica' &&
                     input$eixo_mortes_ufs_alt == 'Dias desde 0,1 mortes por 100 mil hab.') {
                
                mortes_ufs <- ggplotly(ggplot(data = selected_ufs5 , 
                                              aes(days_since_pointone_deaths100k, mortes_100k)) +
                                           geom_line(mapping = aes(days_since_pointone_deaths100k, mortes_100k, color = UF),  size = 0.2) + 
                                           geom_line(data = selected_ufs5 %>% filter(UF %in% input$highlight_uf5), size = 1,
                                                     mapping = aes(x = days_since_pointone_deaths100k, y = mortes_100k), color = Brazil) +
                                           geom_point(aes(color = UF), pch = 21, size = 0.5) +
                                           
                                           scale_y_log10(limits = c(0.1, NA), 
                                                         breaks = breaks_ufs4, labels = breaks_ufs4) +
                                           
                                           theme_minimal(base_size = 14) +
                                           theme(
                                               panel.grid.minor = element_blank(),
                                               legend.position = "none",
                                               plot.margin = margin(3,15,3,3,"mm")
                                           ) +
                                           coord_cartesian(clip = "off") +
                                           ggtitle("UFs - Mortes por 100 mil habitantes") +
                                           labs(x = "Dias desde 0,1 mortes por 100 mil habitantes", 
                                                y = "Mortes por 100 mil habitantes")) %>%
                    config(locale = 'pt-BR')
            } # end else if 6
            
            
            
            mortes_ufs
            
        }) # end renderPlotly
        
        
        ## Mortes Brasil e UF selecionada
        mortes_brasil_last <- ifelse( deaths_uf %>% filter(UF %in% "Brasil") %>% top_n(1, date) %>% dplyr::select(deaths) > 
                                          deaths_uf %>% filter(UF %in% "Brasil") %>% top_n(2, date) %>% slice(1) %>% dplyr::select(deaths), 
                                      deaths_uf %>% filter(UF %in% "Brasil") %>% top_n(1, date) %>% dplyr::select(deaths),
                                      deaths_uf %>% filter(UF %in% "Brasil") %>% top_n(2, date) %>% slice(1) %>% dplyr::select(deaths)
        ) # selecionar o último maior dado p/ Brasil (necessário devido às somas parciais intradia)
        
        
        mortes_last_values <- deaths_uf %>%
            group_by(UF) %>%
            top_n(1, date)
        
        # Brasil
        output$total_deaths_br <- renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"6\">", 
                        formatC(as.numeric(mortes_brasil_last), 
                                big.mark = ".", decimal.mark = ",", format = "d"),
                        "</font></font></b>"))
        })
        
        # UF:
        output$UF_deaths_total <- renderText({
            HTML(paste0("<b>", "Em ", input$highlight_uf5, ":", "</b>")) })
        
        
        output$total_deaths_uf <-  renderText({
            HTML(paste0("<b><font color=\"#FF0000\"><font size=\"6\">", 
                        formatC(as.numeric(mortes_last_values[mortes_last_values$UF == c(input$highlight_uf5), ]$deaths), 
                                big.mark = ".", decimal.mark = ",", format = "d"), 
                        "</font></font></b>"))
        })
        
        
    }) # end observe
    
    
    # Menu 2, Aba 5: UFs - novos casos diários e fator de crescimento (por UF) ----
    
    observe({
        
        selected_uf6 <- ufs_dia1 %>% filter(UF %in% input$ufs6)
        
        ma_uf_casos <- sma(selected_uf6$newCases, order = 5) # Média móvel 5 dias
        ma_uf_deaths <- sma(selected_uf6$newDeaths, order = 5) # Média móvel 5 dias
        
        ma_uf_casos_7 <- sma(selected_uf6$newCases, order = 7) # Média móvel 7 dias
        ma_uf_deaths_7 <- sma(selected_uf6$newDeaths, order = 7) # Média móvel 7 dias
        
        selected_uf6$MA5_casos <- ma_uf_casos$fitted
        selected_uf6$MA5_deaths <- ma_uf_deaths$fitted
        
        selected_uf6$MA7_casos <- ma_uf_casos_7$fitted
        selected_uf6$MA7_deaths <- ma_uf_deaths_7$fitted
        
        
        selected_uf6_2 <- growth_share %>% filter(UF %in% input$ufs6)
        
        # Novos casos
        output$serie_uf6_1 <- renderPlotly({
            
            plot_ufs_deaths <- ggplotly(ggplot(selected_uf6) +
                                            geom_bar(aes(x = date, y = newCases), stat = "identity") +
                                            scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                            geom_line(aes(x = date, y = MA5_casos, color="Média Móvel (5 dias)"), size=0.6) +
                                            geom_line(aes(x = date, y = MA7_casos, color="Média Móvel (7 dias)"), size=0.6) + 
                                            
                                            theme_minimal(base_size = 14) +
                                            theme(
                                                legend.position = 'top', legend.title = element_blank(),
                                                panel.grid.minor = element_blank(),
                                                plot.margin = margin(3,15,3,3,"mm"),
                                                axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                            ) +
                                            coord_cartesian(clip = "off") +
                                            ggtitle(paste0("Novos casos diários - ", input$ufs6)) +
                                            labs(x = "Data", y = "Número de novos casos diários")) %>%
                layout(legend = list(orientation = "h", x = 0.05, y =1)) %>%
                config(locale = 'pt-BR') 
            
            if (input$var_uf6 == "Mortes") {
                
                plot_ufs_deaths <- ggplotly(ggplot(selected_uf6) +
                                                geom_bar(aes(x = date, y = newDeaths), stat = "identity") +
                                                scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                                geom_line(aes(x = date, y = MA5_deaths, color="Média Móvel (5 dias)"), size=0.6) +
                                                geom_line(aes(x = date, y = MA7_deaths, color="Média Móvel (7 dias)"), size=0.6) + 
                                                
                                                theme_minimal(base_size = 14) +
                                                theme(
                                                    legend.position = 'top', legend.title = element_blank(),
                                                    panel.grid.minor = element_blank(),
                                                    plot.margin = margin(3,15,3,3,"mm"),
                                                    axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                                ) +
                                                coord_cartesian(clip = "off") +
                                                ggtitle(paste0("Novos óbitos diários - ", input$ufs6)) +
                                                labs(x = "Data", y = "Número de novos óbitos diários")) %>%
                    layout(legend = list(orientation = "h", x = 0.05, y =1)) %>%
                    config(locale = 'pt-BR') 
                
            }
            
            plot_ufs_deaths
            
        }) # end renderPlotly 6_1
        
        # Fator de crescimento   
        output$serie_uf6_2 <- renderPlotly({
            
            plot_ufs_growth <- ggplotly(ggplot(selected_uf6_2) +
                                            geom_line(aes(x = date, y = growth)) +
                                            geom_line(mapping = aes(date, 1), linetype = "dotted",  size = 0.2) +
                                            scale_y_continuous(breaks = seq(1:10), limits = c(0,max(selected_uf6_2$growth))) +
                                            scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                            theme_minimal(base_size = 14) +
                                            theme(
                                                panel.grid.minor = element_blank(),
                                                plot.margin = margin(3,15,3,3,"mm"),
                                                axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                            ) +
                                            coord_cartesian(clip = "off", ylim = c(0,min(max(selected_uf6_2$growth), 10))) +
                                            ggtitle(paste0("Fator de crescimento - ", input$ufs6)) +
                                            labs(x = "Data", y = "Fator de crescimento diário")) %>%
                config(locale = 'pt-BR')
            
            if (input$var_uf6 == "Mortes") {
                
                plot_ufs_growth <- ggplotly(ggplot(selected_uf6_2) +
                                                geom_line(aes(x = date, y = growth_deaths)) +
                                                geom_line(mapping = aes(date, 1), linetype = "dotted",  size = 0.2) +
                                                scale_y_continuous(breaks = seq(1:10), limits = c(0,max(selected_uf6_2$growth_deaths))) +
                                                scale_x_date(date_breaks = "10 days", date_labels = "%d-%m-%Y") +
                                                theme_minimal(base_size = 14) +
                                                theme(
                                                    panel.grid.minor = element_blank(),
                                                    plot.margin = margin(3,15,3,3,"mm"),
                                                    axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                                                ) +
                                                coord_cartesian(clip = "off", ylim = c(0,min(max(selected_uf6_2$growth_deaths), 10))) +
                                                ggtitle(paste0("Fator de crescimento dos novos óbitos", input$ufs6)) +
                                                labs(x = "Data", y = "Fator de crescimento diário")) %>%
                    config(locale = 'pt-BR')
                
            }
            
            plot_ufs_growth
            
        }) # end renderPlotly 3_2
        
    }) #end observe
    
    
    # Menu 2, Aba 6: UFs - Tempo para duplicação de casos e mortes ----
    
    function_dobra <- function(x_var, date_var, new_var) { # função para encontrar quando valores dobram (usar com dplyr)
        for(i in (x_var)[1]) 
            for(j in seq_along(x_var))
                if(x_var[j]/x_var[i] >= 2){
                    new_var[j] <- as.character(date_var[j])
                    break() 
                }
        
        for(k in seq_along(new_var))
            if(is.na(new_var[k]) == FALSE)
                for(j in seq_along(x_var))
                    if(x_var[j]/x_var[k] >= 2){
                        new_var[j] <- as.character(date_var[j])
                        break() 
                    }  
        
        new_var
    }
    
    
    ufs_dobra_casos <- ufs_dia1 %>%
        group_by(UF) %>%
        mutate(dobra_casos = NA) %>%
        mutate(dobra_casos = function_dobra(confirm, date, dobra_casos)) %>%
        mutate(dobra_casos = as.Date(dobra_casos, tryFormats = c("%Y-%m-%d"))) %>%
        ungroup
    
    
    ufs_dobra_mortes <- ufs_dia1 %>%
        filter(deaths > 0) %>%
        group_by(UF) %>%
        mutate(dobra_mortes = NA) %>%
        mutate(dobra_mortes = function_dobra(deaths, date, dobra_mortes)) %>%
        mutate(dobra_mortes = as.Date(dobra_mortes, tryFormats = c("%Y-%m-%d"))) %>%
        ungroup
    
    x2 <- "Duplicação dos casos" 
    
    observe({
        
        selected_uf7_1 <-  ufs_dobra_casos %>% filter(UF %in% input$ufs7)
        selected_uf7_2 <-  ufs_dobra_mortes %>% filter(UF %in% input$ufs7)
        
        # Duplicação de casos
        output$serie_uf7_1 <- renderPlotly({ 
            
            ggplotly(ggplot(data = selected_uf7_1, 
                            aes(date, confirm)) +
                         geom_line(mapping = aes(date, confirm, color = UF),  size = 0.2) + 
                         geom_vline(aes(xintercept = as.numeric(dobra_casos), date = as.Date(dobra_casos), color = x2)) +
                         
                         geom_point(aes(color = UF), pch = 21, size = 0.5) +
                         scale_x_date(date_breaks = "10 days", date_labels = "%d-%m") +
                         scale_y_log10() +
                         theme_minimal(base_size = 14) +
                         theme(
                             panel.grid.minor = element_blank(),
                             legend.position = 'top', legend.title = element_blank(),
                             plot.margin = margin(3,15,10,3,"mm"),
                             axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                         ) +
                         coord_cartesian(clip = "off") +
                         ggtitle(paste0("Intervalos entre duplicação de casos confirmados em ", input$ufs7)) +
                         labs(x = "Data", y = "Casos confirmados (escala logarítmica)"),
                     tooltip = c("date", "confirm")) %>%
                layout(legend = list(orientation = "v", x = .8, y=.1)) %>%
                config(locale = 'pt-BR')
        })
        
        
        # Duplicação de mortes
        output$serie_uf7_2 <- renderPlotly({ 
            
            ggplotly(ggplot(data = selected_uf7_2, 
                            aes(date, deaths)) +
                         geom_line(mapping = aes(date, deaths, color = UF),  size = 0.2) + 
                         geom_vline(aes(xintercept = as.numeric(dobra_mortes), date = as.Date(dobra_mortes), color = x2)) +
                         
                         geom_point(aes(color = UF), pch = 21, size = 0.5) +
                         scale_x_date(date_breaks = "10 days", date_labels = "%d-%m") +
                         scale_y_log10() +
                         theme_minimal(base_size = 14) +
                         theme(
                             panel.grid.minor = element_blank(),
                             legend.position = 'top', legend.title = element_blank(),
                             plot.margin = margin(3,15,10,3,"mm"),
                             axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
                         ) +
                         coord_cartesian(clip = "off") +
                         ggtitle(paste0("Intervalos entre duplicação de mortes em ", input$ufs7)) +
                         labs(x = "Data", y = "Mortes confirmadas (escala logarítmica)"),
                     tooltip = c("date", "deaths")) %>%
                layout(legend = list(orientation = "v", x = .8, y=.1)) %>%
                config(locale = 'pt-BR')
            
        })
        
    }) # end observe
    
    
   
    # Menu 3, Aba 1: Municípios - Mapas de casos e mortes ----
    
    ## Unir dados da data selecionada ao shape de municípios
    data_shp_mun <- reactive({
        
        mun_br_dados <- shp_mun_br %>%
            left_join(., data_mun %>% group_by(city) %>% filter(date %in% input$map_mun_date), 
                      by = "CD_GEOCMU", keep = F)
        mun_br_dados
    })
    
    ## labels
    label_municipios <- reactive({
        dados_municipios <- data_shp_mun()
        paste0("<strong>", dados_municipios$NM_MUNICIP, "</strong>",
               "<br />Casos confirmados até ", format(as.Date(dados_municipios$date), "%d/%m/%y"), ": ", dados_municipios$confirmed,
               "<br />Mortes confirmadas até ", format(as.Date(dados_municipios$date), "%d/%m/%y"), ": ", dados_municipios$deaths)
    })
    
    
    label_municipios_100k <- reactive({
        dados_municipios <- data_shp_mun()
        paste0("<strong>", dados_municipios$NM_MUNICIP, "</strong>",
               "<br />Casos por 100 mil habitantes <br /> confirmados até ", format(as.Date(dados_municipios$date), "%d/%m/%y"), ": ", round(dados_municipios$confirmed_per_100k_inhabitants, 2),
               "<br />Mortes por 100 mil habitantes <br /> confirmadas até ", format(as.Date(dados_municipios$date), "%d/%m/%y"), ": ", round(dados_municipios$deaths_per_100k, 2))
    })
    
    
    
    ## Renderizar mapa
    output$mapa_mun1 <- renderLeaflet({ 
        mun_br_dados <- data_shp_mun()
        leaflet(options = leafletOptions(zoomSnap = 0.5,
                                         zoomDelta = 0.5, 
                                         wheelPxPerZoomLevel = 150)) %>%  
            setView(lat = -15, lng = -50, zoom = 4.5) %>%
            addLayersControl(baseGroups = c("Mapa de pontos", "Mapa coroplético"),
                             options = layersControlOptions(collapsed = F)) %>%
            addProviderTiles("OpenStreetMap.Mapnik", group = 'OSM', 
                             options = providerTileOptions(opacity = 0.7))
        
    })
    
    
    # Atualizar mapa
    # Casos - valores absolutos
    observe({
        mun_br_dados <- data_shp_mun()
        bins_mapa <- unique(BAMMtools::getJenksBreaks(mun_br_dados$confirmed, 10))
        n_bins <- length(unique(BAMMtools::getJenksBreaks(mun_br_dados$confirmed, 10)))
        
        if (input$mun_var1 == 'Casos confirmados' && input$escala_mun1 == "Valor absoluto") {
            req(input$selected_menu == "Mapas de casos e mortes nos municípios") # Only display if tab is 
            
            leafletProxy('mapa_mun1') %>% 
                clearMarkers() %>% clearMarkerClusters() %>% clearShapes() %>% clearControls() %>%
                addCircleMarkers(data = mun_br_dados, lat = ~Ycoord, lng = ~ Xcoord, group = "Mapa de pontos",
                                 weight = 1, radius = ~(confirmed)^(1/3), fillOpacity = 0.7,
                                 color = ~colorBin(palette = "viridis", domain = confirmed, 
                                                   bins = bins_mapa, 
                                                   reverse = FALSE, pretty = FALSE,
                                                   na.color = "#FFFAFA")(confirmed),
                                 label= lapply(label_municipios(), HTML)) %>%
                addPolygons(data = mun_br_dados, group = "Mapa coroplético",
                            stroke = TRUE, color = "#666", weight = 1, fillOpacity = 0.5, opacity = 0.6,
                            fillColor = ~colorBin(palette = "viridis", domain = confirmed, 
                                                  bins = bins_mapa, 
                                                  reverse = FALSE, pretty = FALSE,
                                                  na.color = "#FFFAFA")(confirmed),
                            label= lapply(label_municipios(), HTML), 
                            highlight = highlightOptions(
                                weight = 5,
                                color = "#666",
                                fillOpacity = 0
                            )) %>%
                addLegend(position = "bottomleft", 
                          colors = viridis(n_bins), 
                          labels = as.character(bins_mapa), 
                          opacity = 0.6,
                          title = "Casos confirmados")
        }
    })
    
    # Mortes - valores absolutos
    observe({
        mun_br_dados <- data_shp_mun()
        bins_mapa <- unique(BAMMtools::getJenksBreaks(mun_br_dados$deaths, 10))
        n_bins <- length(unique(BAMMtools::getJenksBreaks(mun_br_dados$deaths, 10)))
        
        if (input$mun_var1 == 'Mortes' && input$escala_mun1 == "Valor absoluto") {
            
            leafletProxy('mapa_mun1') %>% 
                clearMarkers() %>% clearMarkerClusters() %>% clearShapes() %>% clearControls() %>%
                addCircleMarkers(data = mun_br_dados, lat = ~Ycoord, lng = ~ Xcoord, group = "Mapa de pontos",
                                 weight = 0.5, radius = ~(deaths)^(1/3), fillOpacity = 1, opacity = 1,
                                 color = ~colorBin(palette = "viridis", domain = deaths, 
                                                   bins = bins_mapa, 
                                                   reverse = FALSE, pretty = FALSE,
                                                   na.color = "#FFFAFA")(deaths),
                                 label= lapply(label_municipios(), HTML)) %>%
                addPolygons(data = mun_br_dados, group = "Mapa coroplético",
                            stroke = TRUE,  color = "#666", weight = 1, fillOpacity = 0.5, opacity = 0.6,
                            fillColor = ~colorBin(palette = "viridis", domain = deaths, 
                                                  bins = bins_mapa, 
                                                  reverse = FALSE, pretty = FALSE,
                                                  na.color = "#FFFAFA")(deaths),
                            label= lapply(label_municipios(), HTML), 
                            highlight = highlightOptions(
                                weight = 5,
                                color = "#666",
                                fillOpacity = 0
                            )) %>%
                addLegend(position = "bottomleft", 
                          colors = viridis(n_bins), 
                          labels = as.character(bins_mapa),
                          opacity = 0.6,
                          title = "Mortes")
            
        }
    })
    
    
    # Casos - valores por 100k
    observe({
        mun_br_dados <- data_shp_mun()
        bins_mapa <- unique(BAMMtools::getJenksBreaks(mun_br_dados$confirmed_per_100k_inhabitants, 10))
        n_bins <- length(unique(BAMMtools::getJenksBreaks(mun_br_dados$confirmed_per_100k_inhabitants, 10)))
        
        if (input$mun_var1 == 'Casos confirmados' && input$escala_mun1 == "Valor por 100 mil habitantes") {
            req(input$selected_menu == "Mapas de casos e mortes nos municípios") # Only display if tab is 
            
            leafletProxy('mapa_mun1') %>% 
                clearMarkers() %>% clearMarkerClusters() %>% clearShapes() %>% clearControls() %>%
                addCircleMarkers(data = mun_br_dados, lat = ~Ycoord, lng = ~ Xcoord, group = "Mapa de pontos",
                                 weight = 1, radius = ~(confirmed_per_100k_inhabitants)^(1/3), fillOpacity = 0.7,
                                 color = ~colorBin(palette = "viridis", domain = confirmed_per_100k_inhabitants, 
                                                   bins = bins_mapa, 
                                                   reverse = FALSE, pretty = FALSE,
                                                   na.color = "#FFFAFA")(confirmed_per_100k_inhabitants),
                                 label= lapply(label_municipios_100k(), HTML)) %>%
                addPolygons(data = mun_br_dados, group = "Mapa coroplético",
                            stroke = TRUE,  color = "#666", weight = 1, fillOpacity = 0.5, opacity = 0.6,
                            fillColor = ~colorBin(palette = "viridis", domain = confirmed_per_100k_inhabitants, 
                                                  bins = bins_mapa, 
                                                  reverse = FALSE, pretty = FALSE,
                                                  na.color = "#FFFAFA")(confirmed_per_100k_inhabitants),
                            label= lapply(label_municipios_100k(), HTML), 
                            highlight = highlightOptions(
                                weight = 5,
                                color = "#666",
                                fillOpacity = 0
                            )) %>%
                addLegend(position = "bottomleft", 
                          colors = viridis(n_bins), 
                          labels = as.character(bins_mapa), 
                          opacity = 0.6,
                          title = "Casos confirmados por 100 mil hab.")
        }
    })
    
    
    # Mortes - valores por 100k
    observe({
        mun_br_dados <- data_shp_mun()
        bins_mapa <- unique(BAMMtools::getJenksBreaks(mun_br_dados$deaths_per_100k, 10))
        n_bins <- length(unique(BAMMtools::getJenksBreaks(mun_br_dados$deaths_per_100k, 10)))
        
        if (input$mun_var1 == 'Mortes' && input$escala_mun1 == "Valor por 100 mil habitantes") {
            
            leafletProxy('mapa_mun1') %>% 
                clearMarkers() %>% clearMarkerClusters() %>% clearShapes() %>% clearControls() %>%
                addCircleMarkers(data = mun_br_dados, lat = ~Ycoord, lng = ~ Xcoord, group = "Mapa de pontos",
                                 weight = 0.5, radius = ~(deaths_per_100k)^(1/3), fillOpacity = 1, opacity = 1,
                                 color = ~colorBin(palette = "viridis", domain = deaths_per_100k, 
                                                   bins = bins_mapa, 
                                                   reverse = FALSE, pretty = FALSE,
                                                   na.color = "#FFFAFA")(deaths_per_100k),
                                 label= lapply(label_municipios_100k(), HTML)) %>%
                addPolygons(data = mun_br_dados, group = "Mapa coroplético",
                            stroke = TRUE, color = "#666", weight = 1, fillOpacity = 0.5, opacity = 0.6,
                            fillColor = ~colorBin(palette = "viridis", domain = deaths_per_100k, 
                                                  bins = bins_mapa, 
                                                  reverse = FALSE, pretty = FALSE,
                                                  na.color = "#FFFAFA")(deaths_per_100k),
                            label= lapply(label_municipios_100k(), HTML), 
                            highlight = highlightOptions(
                                weight = 5,
                                color = "#666",
                                fillOpacity = 0
                            )) %>%
                addLegend(position = "bottomleft", 
                          colors = viridis(n_bins), 
                          labels = as.character(bins_mapa),
                          opacity = 0.6,
                          title = "Mortes por 100 mil hab.")
            
        }
    })
    
    
