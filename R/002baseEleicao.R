


get_eleicao <- function(url, cond, uma_cond, cod_uf){

  `%>%` <- magrittr::`%>%`

  url %>% readr::read_rds() %>%
    dplyr::filter(reeleicao %in% cond) %>%
    dplyr::mutate(d_reeleicao = base::ifelse(reeleicao == uma_cond, 1, 0),
                  c_uf = as.integer(substr(codibge,1,2))) %>%
    dplyr::filter(c_uf %in% cod_uf) %>%
    dplyr::relocate(c_uf, .before = codibge)

}

h <- get_eleicao('data-raw/df_reeleitos_20_detalhada.rds',
                 cond = c('reeleito', 'naoReeleito'),
                 uma_cond = 'naoReeleito', cod_uf = c(23))

readr::write_rds(h, 'data/df_naoReeleitoCE.rds')

