

`%>%` <- magrittr::`%>%`
dados <- readr::read_rds('data/dados.rds') %>%
  dplyr::mutate(porte_cidade = dplyr::case_when(
    pop19 <= 10000 ~ 'Nivel 1',
    pop19 > 10000 & pop19 <= 30000 ~ 'Nivel 2',
    pop19 > 30000 & pop19 <= 60000 ~ 'Nivel 3',
    pop19 > 60000 & pop19 <= 200000 ~ 'Nivel 4',
    pop19 > 200000 ~ 'Nivel 5'
  )) %>%  dplyr::relocate(reeleicao:d_reeleicao, porte_cidade, .before = pop19)


# Mapa ----
 # Mostrar os municípios eleitos e não reeleitos


mun <- geobr::read_municipality(code_muni = 'CE') %>%
  dplyr::select(code_muni, geom) %>%
  dplyr::left_join(dados, by = c('code_muni'='codibge'))

readr::write_rds(mun, 'data/dados_geom.rds')


mun %>% ggplot2::ggplot(ggplot2::aes(fill = reeleicao))+
  ggplot2::geom_sf()+
  ggplot2::labs(title = 'Municípios cearenses.', fill = '')+
  ggplot2::theme_minimal()+
  ggplot2::scale_fill_viridis_d(option = "plasma",
                                labels = c("Não Reeleito", "Reeleito",
                                           "Não Disponível"))+
  ggplot2::theme(legend.position = 'bottom',
                 plot.title = ggplot2::element_text(hjust = 0.5, size = 12),
        text = ggplot2::element_text(family="Times New Roman", color="black",
                            size=12, face="bold"),
        axis.title=ggplot2::element_blank(),
        axis.text=ggplot2::element_blank(),
        axis.ticks=ggplot2::element_blank())+
  ggplot2::guides(ggplot2::guide_legend(title.position = 'none'))



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


# Gráficos


graf_hist <- function(base, indicador, titulo, eixo_x){

  base %>%
    ggplot2::ggplot(ggplot2::aes(x = {{indicador}}))+
    ggplot2::geom_histogram(bins = 10, fill = 'lightblue', color = 'gray')+
    ggplot2::theme_minimal()+
    ggplot2::labs(title = titulo,
                  x = eixo_x,
                  y = 'Contagem dos municípios')
}

d <- graf_hist(base=dados, indicador= log(confirmed_100k),
               titulo = 'Distribuição dos casos confirmados por 100k de hab',
               eixo_x = 'Casos confirmados por 100k de hab')
d
d1 <- graf_hist(base=dados, indicador = log(deaths_100k),
                titulo = 'Distribuição Mortes por 100k de hab',
                eixo_x = 'Mortes por 100k hab')
d1

cowplot::plot_grid(d, d1)

## Regressão simples

reg_1 <- lm(data = dados, log(confirmed_100k) ~ d_reeleicao)

reg_2 <- lm(data = dados, log(deaths_100k) ~ d_reeleicao)

stargazer::stargazer(reg, type = 'text')



## Regressão multipla


mob <- readr::read_rds('data-raw/mob_google_mun.RDS') %>%
  dplyr::filter(sigla_uf == 'CE') %>%
  dplyr::select(cod_municipio7, indice_mob = localTrab) %>%
  dplyr::left_join(dados, by = c('cod_municipio7'='codibge')) %>%
  tidyr::drop_na(deaths_100k)






stargazer::stargazer(reg_1, reg_2, type = 'text',
                     title = "Regressões de Mínimos Quadrados Ordninários.",
                     dep.var.caption = 'Variável Dependente',
                     omit.table.layout = c('n'),
                     omit.stat=c("LL","ser","f")
                     )



