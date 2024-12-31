 ################## SETUP ##################
  #modificado em 07-jun-2021, 12:27h)
 
 library(tidyr)
 library(dplyr)
 library(shadowtext)
 library(ggrepel)
 library(ggplot2)
 library(plotly)
 library(stringr)
 library(lubridate)
 library(readr)

 library(smooth)
 library(htmltools)
 library(viridis)
 library(BAMMtools)

 library(highcharter)
 library(nCov2019)
 library(coronabr)

 options(rsconnect.error.trace = TRUE) 
 options(scipen = 999)

# Carregar dados gerais (população e códigos das UFS e shape dos municípios brasileiros):
 load("/home/sdc_nietta/scripts/covid/arquivos_casos/data_status.RData")

################# BASES DE DADOS E TRANSFORMAÇÕES #################

# Base de população dos países:
 populacao_paises <- read.csv(paste0("https://raw.githubusercontent.com/owid/owid-datasets/master/datasets/Life%20expectancy",
                                    "%20%26%20population%20-%20Gapminder%20(2019)%2C%20UN%20(2019)%2C%20and%20Our%20World%20",
                                    "In%20Data%20(2019)/Life%20expectancy%20%26%20population%20-%20Gapminder%20(2019)%2C%20",
                                    "UN%20(2019)%2C%20and%20Our%20World%20In%20Data%20(2019).csv"), stringsAsFactors = F, encoding = "UTF-8") %>%
    dplyr::filter(Year == 2019) %>%
    dplyr::select(., -c(Life.expectancy)) %>%
    rename(country=Entity) %>%
    mutate(pop_100k = Population/100000) %>%
    mutate(country=replace(country, country == "Cape Verde", "Cabo Verde")) %>%
    mutate(country=replace(country, country == "Congo", "Congo (Brazzaville)")) %>%
    mutate(country=replace(country, country == "Democratic Republic of Congo", "Congo (Kinshasa)")) %>%
    mutate(country=replace(country, country == "Swaziland", "Eswatini"))


# Base global de casos confirmados
 y <- tryCatch(read_csv(url('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv')) %>%
                  gather(., key = 'data', value = 'n', -c(`Province/State`:Long)) %>%
                  mutate(data = mdy(data)) %>%
                  dplyr::filter(n > 0) %>%
                  rename(cum_confirm=n) %>%
                  rename(country=`Country/Region`) %>%
                  rename(time=data) %>%
                  mutate(country=replace(country, country == "US", "United States")) %>%
                  mutate(country=replace(country, country == "Taiwan*", "Taiwan")) %>%
                  mutate(country=replace(country, country == "Korea, South", "South Korea")) %>%
                  mutate(country=replace(country, country == "Czechia", "Czech Republic")) %>%
                  dplyr::filter(!country %in% c("Cruise Ship")) %>%
                  dplyr::filter(!country %in% c("Diamond Princess")) %>%
                  group_by(country, time) %>%
                  summarise(cum_confirm = sum(cum_confirm)) %>%
                  ungroup, # Inicialmente tentando pegar base da Johns Hopkins e trabalhando os dados
              error=function(e) load_nCov2019(lang = 'en', source='github')['global'] )  # se falhar, pegar dados dos chineses

## Recorte global a partir do dia 1
dia1_global <- y %>% 
    as_tibble %>%
    rename(confirm=cum_confirm) %>%
    group_by(country) %>%
    mutate(days_since_1 = as.numeric(time - min(time))) %>%
    ungroup 

# Base com novos casos e fator de crescimento dos países (acima de 50 casos)
growth_newcases <- dia1_global %>% 
    as_tibble %>%
    dplyr::filter(confirm > 50) %>%
    group_by(country) %>%
    mutate(new_cases = confirm - lag(confirm)) %>%
    mutate(growth = (confirm - lag(confirm))/(lag(confirm) - lag(lag(confirm)))) %>%
    mutate_at(vars(growth), ~replace(., is.nan(.), 0)) %>%
    mutate_at(vars(growth), ~replace(., is.na(.), 0)) %>%
    mutate_at(vars(growth), ~replace(., is.infinite(.), 0)) %>%
    ungroup


## Base global de mortes
d <- tryCatch(read_csv(url('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv')) %>%
                  gather(., key = 'data', value = 'n', -c(`Province/State`:Long)) %>%
                  mutate(data = mdy(data)) %>%
                  dplyr::filter(n > 0) %>%
                  rename(cum_dead=n) %>%
                  rename(country=`Country/Region`) %>%
                  rename(time=data) %>%
                  mutate(country=replace(country, country == "US", "United States")) %>%
                  mutate(country=replace(country, country == "Taiwan*", "Taiwan")) %>%
                  mutate(country=replace(country, country == "Korea, South", "South Korea")) %>%
                  mutate(country=replace(country, country == "Czechia", "Czech Republic")) %>%
                  dplyr::filter(!country %in% c("Cruise Ship")) %>%
                  dplyr::filter(!country %in% c("Diamond Princess")) %>%
                  group_by(country, time) %>%
                  summarise(cum_dead = sum(cum_dead)) %>%
                  ungroup %>%
                  left_join(., y, by = c("time" = "time", "country" = "country")), # Inicialmente tentando pegar base da Johns Hopkins e trabalhando os dados
              error=function(e) load_nCov2019(lang = 'en', source='github')['global'] %>% filter(cum_dead > 0) %>% dplyr::select(., -c(cum_heal)))  # se falhar, pegar dados dos chineses


world_deaths <- d %>% 
    group_by(time) %>%
    summarise_at(
        .vars= vars(cum_confirm, cum_dead), 
        .funs =  sum) %>%
    rename(deaths=cum_dead) %>%
    rename(confirm=cum_confirm) %>%
    mutate(country = "World") %>%
    .[c(1,4,2,3)] %>%
    mutate(days_since_1 = as.numeric(time - min(time))) %>%
    mutate(cfr = (deaths/confirm)*100) # case fatality rate


deaths_global <- d %>% 
    as_tibble %>%
    rename(deaths=cum_dead) %>%
    rename(confirm=cum_confirm) %>%
    dplyr::filter(confirm > 50) %>%
    group_by(country) %>%
    mutate(days_since_1 = as.numeric(time - min(time))) %>%
    mutate(cfr = (deaths/confirm)*100) %>% # case fatality rate
    ungroup %>%
    bind_rows(., world_deaths) %>%
    mutate(cfr = round(cfr, digits = 2)) %>%
    group_by(country) %>%
    mutate(new_deaths = deaths - lag(deaths)) %>% # new deaths
    mutate(growth_deaths = (deaths - lag(deaths))/(lag(deaths) - lag(lag(deaths)))) %>% #growth factor of new deaths
    mutate_at(vars(growth_deaths), ~replace(., is.nan(.), 0)) %>%
    mutate_at(vars(growth_deaths), ~replace(., is.na(.), 0)) %>%
    mutate_at(vars(growth_deaths), ~replace(., is.infinite(.), 0)) %>%
    ungroup %>%
    left_join(., dplyr::select(populacao_paises, c("country", "pop_100k")), by = "country") %>%
    mutate(deaths_100k = round(((as.numeric(deaths)/as.numeric(pop_100k))), digits = 2)) %>%
    group_by(country) %>%
    mutate(days_since_pointone_deaths100k = ifelse (deaths_100k > 0.1, deaths_100k, NA)) %>%
    mutate(days_since_pointone_deaths100k = ifelse(!is.na(days_since_pointone_deaths100k), 
                                                   dplyr::row_number() - sum(is.na(days_since_pointone_deaths100k)), NA)) %>%
    ungroup



# Criar novas bases para análise conjunta de casos e mortes por 100 mil habitantes
y_d100 <- y %>% 
    dplyr::filter(cum_confirm > 100) %>%
    group_by(country) %>%
    mutate(days_since_100_cases = as.numeric(time - min(time))) 

y_d <- left_join(y, y_d100, by = c("country", "time"), keep = F) %>% 
    dplyr::select(., -c(cum_confirm.y)) %>%
    rename(confirm=cum_confirm.x) %>%
    mutate(days_since_100_cases=replace(days_since_100_cases, is.na(days_since_100_cases), 0))

d_d <- d %>% 
    dplyr::select(., -c(cum_confirm)) %>%
    group_by(country) %>%
    mutate(days_since_1st_death = as.numeric(time - min(time))) 

d_d <- left_join(d, d_d, by = c("country", "time", "cum_dead"), keep = F) %>% 
    dplyr::select(., -c(cum_confirm)) %>%
    rename(deaths=cum_dead)

casos_mortes <- left_join(y_d, d_d, by = c("country", "time")) %>%
    mutate(deaths=replace(deaths, is.na(deaths), 0)) %>%
    mutate(days_since_1st_death=replace(days_since_1st_death, is.na(days_since_1st_death), 0))

mortes_casos_100k <- inner_join(populacao_paises, casos_mortes, by = "country") %>%
    dplyr::select(., -c(Year)) %>%
    mutate(deaths_per_100k = deaths/pop_100k) %>%
    mutate(cases_per_100k = confirm/pop_100k) %>%
    group_by(country) %>%
    mutate(days_since_pointone_cases100k = ifelse (cases_per_100k > 0.1, cases_per_100k, NA)) %>%
    mutate(days_since_pointone_cases100k = ifelse(!is.na(days_since_pointone_cases100k), 
                                                  dplyr::row_number() - sum(is.na(days_since_pointone_cases100k)), NA))

#### Bases dos estados:
ufs_full_data <- read_csv("https://data.brasil.io/dataset/covid19/caso.csv.gz")

# Geral
data_ufs2 <- tryCatch(read.csv("https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-states.csv", # Base prioritária
                              h = T, stringsAsFactors = F) %>%
                         filter(!state %in% c("TOTAL")) %>%
                         rename(Sigla = state) %>%
                         rename(confirm = totalCases) %>%
                         left_join(., cod_ufs, by = "Sigla"), 
                     error=function(e) get_corona(filename = "corona_brasil01") %>% # Alternativa 1
                         rename(Codigos = uid) %>%
                         mutate(Codigos = as.integer(Codigos)) %>%
                         rename(confirm = cases) %>%
                         left_join(., cod_ufs, by = "Codigos")
                    )



data_ufs2$date <- as.Date(data_ufs2$date, tryFormats = c("%Y-%m-%d", "%Y/%m/%d"))

# Unir com população das UFs
ufs_pop <- left_join(cod_ufs, pop_ufs, by=c("Sigla", "Codigos"), keep = F) %>%
    mutate(pop_100k = Pop/100000) %>%
    rename(UF=UFs.x) %>%
    dplyr::select(., -c("UFs.y"))

# Recorte estadual a partir do primeiro caso
ufs_dia1 <- data_ufs2 %>%
    as_tibble %>%
    rename(UF = UFs) %>%
    dplyr::filter(confirm > 0) %>%
    group_by(UF) %>%
    mutate(days_since_1 = as.numeric(date - min(date))) %>%
    ungroup %>%
    left_join(., ufs_pop, by = c("Sigla", "Codigos", "UF"), keep = F) %>%
    mutate(cases_per_100k = confirm/pop_100k) %>%
    group_by(UF) %>%
    mutate(days_since_pointone_cases100k = ifelse (cases_per_100k > 0.1, cases_per_100k, NA)) %>%
    mutate(days_since_pointone_cases100k = ifelse(!is.na(days_since_pointone_cases100k), 
                                                  dplyr::row_number() - sum(is.na(days_since_pointone_cases100k)), NA)) %>%
    ungroup


# Base com dados de fator de crescimento e participação das UFs no total do Brasil
growth_share <- data_ufs2 %>%
    as_tibble %>%
    rename(UF = UFs) %>%
    dplyr::filter(confirm > 0) %>%
    group_by(UF) %>%
    mutate(growth = round((confirm - lag(confirm))/(lag(confirm) - lag(lag(confirm))), digits = 2)) %>% # growth facor of new cases
    mutate_at(vars(growth), ~replace(., is.nan(.), 0)) %>%
    mutate_at(vars(growth), ~replace(., is.na(.), 0)) %>%
    mutate_at(vars(growth), ~replace(., is.infinite(.), 0)) %>%
    mutate(growth_deaths = round((deaths - lag(deaths))/(lag(deaths) - lag(lag(deaths))), digits = 2)) %>% # growth facor of new deaths
    mutate_at(vars(growth_deaths), ~replace(., is.nan(.), 0)) %>%
    mutate_at(vars(growth_deaths), ~replace(., is.na(.), 0)) %>%
    mutate_at(vars(growth_deaths), ~replace(., is.infinite(.), 0)) %>%
    mutate(days_since_1 = as.numeric(date - min(date))) %>%
    ungroup %>%
    group_by(date) %>%
    mutate(share = round((confirm/sum(confirm))*100, digits = 2)) %>%
    ungroup



# Mortes nas UFS
uf_deaths <- tryCatch(ufs_full_data %>% # base prioritária
                          dplyr::filter(place_type %in% c("state")) %>%
                          dplyr::filter(deaths > 0) %>%
                          rename(confirm = confirmed) %>%
                          rename(Sigla = state) %>%
                          left_join(., cod_ufs, by = "Sigla") %>%
                          dplyr::select(., c("date", "confirm", "deaths", "UFs")),
                      error=function(e) tryCatch(read_csv("https://raw.githubusercontent.com/cassianord/mapas_covid_br/master/docs/data/caso.csv.gz") %>%
                                                     dplyr::filter(place_type %in% c("state")) %>%
                                                     dplyr::filter(deaths > 0) %>%
                                                     rename(confirm = confirmed) %>%
                                                     rename(Sigla = state) %>%
                                                     left_join(., cod_ufs, by = "Sigla") %>%
                                                     dplyr::select(., c("date", "confirm", "deaths", "UFs")),
                                                 error=function(e) read.csv('https://brasil.io/dataset/covid19/caso_full/?format=csv', 
                                                                            h = T, stringsAsFactors = F, encoding = "UTF-8") %>%
                                                     dplyr::filter(place_type %in% c("state")) %>%
                                                     rename(Sigla = state) %>%
                                                     rename(confirm = last_available_confirmed) %>%
                                                     rename(deaths = last_available_deaths) %>%
                                                     dplyr::filter(deaths > 0) %>%
                                                     left_join(., ufs_pop, by = "Sigla") %>%
                                                     dplyr::select(., c("date", "confirm", "deaths", "UF")) %>%
                                                     rename(UFs = UF) %>%
                                                     mutate(date = as.Date(date, tryFormats = c("%Y-%m-%d", "%Y/%m/%d")))))

br_deaths <- uf_deaths %>% 
    group_by(date) %>%
    summarise_at(
        .vars= vars(confirm, deaths), 
        .funs =  sum) %>%
    mutate(UFs = "Brasil") %>%
    rename(UF = UFs) %>%
    mutate(days_since_1 = as.numeric(date - min(date)))

deaths_uf <- uf_deaths %>% 
    as_tibble %>%
    rename(UF = UFs) %>%
    group_by(UF) %>%
    mutate(days_since_1 = as.numeric(date - min(date))) %>%
    ungroup %>%
    bind_rows(., br_deaths) %>%
    mutate(cfr = round(((as.numeric(deaths)/as.numeric(confirm)*100)), digits = 2)) %>% # case fatality rate
    left_join(., dplyr::select(ufs_pop, c("UF", "pop_100k")), by = "UF") %>%
    mutate(mortes_100k = round(((as.numeric(deaths)/as.numeric(pop_100k))), digits = 2)) %>%
    .[c(1,4,2,3,5,6,7,8)] %>%
    group_by(UF) %>%
    arrange(date) %>%
    mutate(days_since_pointone_deaths100k = ifelse (mortes_100k > 0.1, mortes_100k, NA)) %>%
    mutate(days_since_pointone_deaths100k = ifelse(!is.na(days_since_pointone_deaths100k), 
                                                   dplyr::row_number() - sum(is.na(days_since_pointone_deaths100k)), NA)) %>%
    ungroup



#### Municípios

## Dados municipais
 data_mun <- tryCatch(read_csv("https://data.brasil.io/dataset/covid19/caso.csv.gz") %>% 
                         dplyr::filter(place_type %in% c("city")) %>%
                         dplyr::filter(confirmed > 0) %>%
                         rename(CD_GEOCMU = city_ibge_code) %>%
                         mutate(deaths_per_100k = (deaths/(estimated_population_2019/100000))),
                     error=function(e) tryCatch(read_csv("https://raw.githubusercontent.com/cassianord/mapas_covid_br/master/docs/data/caso.csv.gz") %>%
                                                    dplyr::filter(place_type %in% c("city")) %>%
                                                    dplyr::filter(confirmed > 0) %>%
                                                    rename(CD_GEOCMU = city_ibge_code) %>%
                                                    mutate(deaths_per_100k = (deaths/(estimated_population_2019/100000))),
                                                error=function(e) read.csv('https://brasil.io/dataset/covid19/caso_full/?format=csv', 
                                                                           h = T, stringsAsFactors = F, encoding = "UTF-8") %>%
                                                    dplyr::filter(place_type %in% c("city")) %>%
                                                    rename(Sigla = state) %>%
                                                    rename(confirmed = last_available_confirmed) %>%
                                                    dplyr::filter(confirmed > 0) %>%
                                                    rename(deaths = last_available_deaths) %>%
                                                    rename(CD_GEOCMU = city_ibge_code) %>%
                                                    mutate(deaths_per_100k = (deaths/(estimated_population_2019/100000))) %>%
                                                    rename(confirmed_per_100k_inhabitants = last_available_confirmed_per_100k_inhabitants) %>%
                                                    mutate(date = as.Date(date, tryFormats = c("%Y-%m-%d", "%Y/%m/%d")))))

## Quebras dos gráficos 
 breaks = c(100,1000,10000,100000,1000000) # após 100 dias - países
 breaks_deaths=c(1, 10, 100, 1000, 10000, 100000) # quebras p/ mortes
 breaks_deaths_100k=c(0.1, 1, 10, 100, 1000) # quebras p/ mortes por 100k
 breaks_ufs = c(1, 10, 100, 1000, 10000, 100000) # UFs a partir do dia 1
 breaks_ufs3 = c(3, 6, 12, 25, 50, 100, 200, 500, 1000, 2000, 4000, 8000, 15000, 30000, 60000)
 breaks_ufs4 = c(0.1, 1, 10, 100, 1000)

 Brazil <- "gray0"
 Tendencia_pessimista <- "red"
 Tendencia_geral <- "grey"
 Tendencia_otimista <- "blue"

 paises_lista <- sort(unique(mortes_casos_100k$country)) # lista de países para UI
 paises_lista_100 <- sort(unique(mortes_casos_100k %>% dplyr::filter(confirm >=100) %>% dplyr::select(country))$country)
 paises_lista_50 <- sort(unique(growth_newcases$country))
 ufs_lista <- sort(unique(data_ufs2$UFs)) # lista de UFs para UI

 save(mortes_casos_100k, y, growth_newcases, deaths_global, ufs_dia1,
  growth_share, deaths_uf, data_mun,breaks,breaks_deaths, breaks_deaths_100k, breaks_ufs ,
  breaks_ufs3, breaks_ufs4, Brazil, Tendencia_pessimista, Tendencia_geral, Tendencia_otimista,
  paises_lista, paises_lista_100, paises_lista_50, ufs_lista,
  data_mun, shp_mun_br, file = '/srv/shiny-server/covidSC/status_data.RData', compress = T)
  
   
  
  
