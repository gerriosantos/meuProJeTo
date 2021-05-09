

get_covid <- function(url, sigla_uf, cod_uf, date_espec = '2020-12-31'){

  `%>%` <- magrittr::`%>%`

  url %>% vroom::vroom(delim = ',') %>%
      dplyr::select(date, state, city_ibge_code, city, estimated_population_2019,
                    confirmed, deaths) %>%
      dplyr::filter(state == sigla_uf & !(city_ibge_code %in% c(cod_uf, NA)) &
                      date == date_espec) %>%
      dplyr::group_by(city_ibge_code, city) %>%
      dplyr::summarise(pop19 = dplyr::first(estimated_population_2019),
                       confirmed = base::round(base::sum(confirmed, na.rm = T), 3),
                       deaths = base::round(base::sum(deaths, na.rm = T), 3),
                       .groups = 'drop') %>%
      dplyr::mutate(confirmed_100k = base::round((confirmed/pop19)*100000,3),
                    deaths_100k = base::round((deaths/pop19)*100000,3))
}

casos <- get_covid(url = 'https://data.brasil.io/dataset/covid19/caso.csv.gz',
                   sigla_uf = 'CE', cod_uf = 23)

readr::write_rds(casos, 'data/df_casos.rds')








