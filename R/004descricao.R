

`%>%` <- magrittr::`%>%`
dados <- readr::read_rds('data/dados.rds') %>%
  dplyr::mutate(porte_cidade = dplyr::case_when(
    pop19 <= 10000 ~ 'Nivel 1',
    pop19 > 10000 & pop19 <= 30000 ~ 'Nivel 2',
    pop19 > 30000 & pop19 <= 60000 ~ 'Nivel 3',
    pop19 > 60000 & pop19 <= 200000 ~ 'Nivel 4',
    pop19 > 200000 ~ 'Nivel 5'
  )) %>%  dplyr::relocate(reeleicao:d_reeleicao, porte_cidade, .before = pop19)

# Tabelas ----

    # Tabela retirando municípios acima de 200 mil habitantes
dados %>%
  dplyr::select(reeleicao,porte_cidade, pop19, confirmed_100k, deaths_100k) %>%
  dplyr::group_by(reeleicao,porte_cidade) %>%
  dplyr::summarise(dplyr::across(
    .cols = pop19:deaths_100k,
    .fns = ~ base::round(base::mean(.x, na.rm = T),2)
  ), .groups = 'drop') %>% knitr::kable(
    caption = 'Média das variáveis comparando os reeleitos e não reeleitos por porte da cidade.',
    align = 'c', col.names = c('Reeleiçao', 'Porte da Cidade', 'População',
                               'Casos Confirmados por 100k de hab', 'Mortes por 100k de hab'),
    format.args = list(big.mark = '.', decimal.mark = ','))





