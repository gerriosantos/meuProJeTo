
#### ELIETOS VC NAO ELEITOS E VS NOVOS CANDIDATOS ELEITOS ----



d <- vroom::vroom('data-raw/consulta_cand_2020_BRASIL.csv', delim = ';',
                  locale = readr::locale(encoding = 'latin1')) %>%
  janitor::clean_names() %>%
  dplyr::mutate(dia = base::as.integer(base::substr(dt_eleicao, 1, 2)),
                mes = base::as.integer(base::substr(dt_eleicao, 4, 5)),
                ano = base::as.integer(base::substr(dt_eleicao, 7, 10)),
                dt_eleicao = lubridate::ymd(paste(ano,mes, dia, sep = '-')),
                nm_tipo_eleicao1 = dplyr::case_when(
                  nm_tipo_eleicao == 'ELEIÇÃO SUPLEMENTAR' &
                    dt_eleicao < '2020-11-15' ~ 'Descarta',
                  nm_tipo_eleicao == 'ELEIÇÃO SUPLEMENTAR' &
                    dt_eleicao > '2020-11-15' ~ 'Mantem',
                  nm_tipo_eleicao == 'ELEIÇÃO ORDINÁRIA' ~ 'Ordinaria'),
                nr_turno = base::ifelse(nr_turno == 1, 'turno1', 'turno2'),
                chave = base::paste0(ds_cargo, nr_cpf_candidato)) %>%
  dplyr::select(chave, ano, nm_tipo_eleicao, nm_tipo_eleicao1, nr_turno, dt_eleicao, sg_uf,
                nm_ue, sg_ue, cd_cargo, ds_cargo, nm_candidato, nr_cpf_candidato,
                ds_sit_tot_turno, st_reeleicao) %>%
  dplyr::filter(ano <=2020, cd_cargo == 11,
                ds_sit_tot_turno == 'ELEITO'| ds_sit_tot_turno == 'NÃO ELEITO')


# contagem do numeros de municipios repetidos
# aqueles que tiveram eleicoes suplementares
cont <- d %>% dplyr::group_by(sg_ue, nm_ue) %>% dplyr::tally()


#### ELEICOES 2016 ----

d1 <- vroom::vroom('data-raw/consulta_cand_2016_BRASIL.csv', delim = ';',
                   locale = readr::locale(encoding = 'latin1')) %>%
  janitor::clean_names() %>%
  dplyr::mutate(dia = base::substr(dt_eleicao, 1, 2),
                mes = base::substr(dt_eleicao, 4, 5),
                ano = base::substr(dt_eleicao, 7, 10),
                dt_eleicao = lubridate::ymd(paste(ano,mes, dia, sep = '-')),
                nm_tipo_eleicao1 = dplyr::case_when(
                  nm_tipo_eleicao == 'ELEIÇÃO SUPLEMENTAR' &
                    dt_eleicao < '2016-10-02' ~ 'Descarta',
                  nm_tipo_eleicao == 'ELEIÇÃO SUPLEMENTAR' &
                    dt_eleicao > '2016-10-02' ~ 'Mantem',
                  nm_tipo_eleicao == 'ELEIÇÃO ORDINÁRIA' ~ 'Ordinaria'),
                nr_turno = base::ifelse(nr_turno == 1, 'turno1', 'turno2'),
                chave = base::paste0(ds_cargo,nr_cpf_candidato)) %>%
  dplyr::select(chave, nm_tipo_eleicao, nm_tipo_eleicao1, nr_turno, dt_eleicao,
                sg_uf, nm_ue, sg_ue, cd_cargo,ds_cargo, nm_candidato, nr_cpf_candidato,
                ds_sit_tot_turno, st_reeleicao) %>%
  dplyr::filter(cd_cargo == 11, ds_sit_tot_turno == 'ELEITO') %>%
  dplyr::group_by(sg_ue) %>%
  dplyr::mutate(contar_duplicatas = base::seq_len(dplyr::n())) %>%
  #Pegar o ultimo ano que o cara fez a eleicao, quando tiver repetida o cpf e a eleicao suplementar
  # queremos pegar a ultima eleicao, que é a suplementar
  dplyr::arrange(desc(dt_eleicao, sg_ue, contar_duplicatas)) %>%
  dplyr::distinct(sg_ue, .keep_all = T) %>%
  dplyr::filter(nr_cpf_candidato != '000000000-4')
# cpf duplicado (provavelmente por nao declaracao)


cont <- d1 %>% dplyr::group_by(chave) %>% dplyr::tally()





merg <- dplyr::left_join(d,d1, by = c('nr_cpf_candidato', 'chave')) %>%
  dplyr::select(ano, chave, dt_eleicao.x, dt_eleicao.y, sg_ue.x,
                sg_ue.y, nm_ue.x, nm_ue.y,nm_candidato.x, nm_candidato.y,
                ds_sit_tot_turno.x, ds_sit_tot_turno.y) %>%
  dplyr::mutate(ds_sit_tot_turno.y = base::ifelse(is.na(ds_sit_tot_turno.y),
                                            'candidatoNovo', ds_sit_tot_turno.y),
         reeleicao = dplyr::case_when(
           ds_sit_tot_turno.y == 'ELEITO' & ds_sit_tot_turno.x == 'ELEITO' ~ 'reeleito',
           ds_sit_tot_turno.y == 'ELEITO' & ds_sit_tot_turno.x == 'NÃO ELEITO' ~ 'naoReeleito',
           ds_sit_tot_turno.y == 'candidatoNovo' & ds_sit_tot_turno.x == 'ELEITO' ~ 'novoEleito',
           ds_sit_tot_turno.y == 'candidatoNovo' & ds_sit_tot_turno.x == 'NÃO ELEITO' ~ 'novoNaoEleito'),
         sg_ue.x = base::as.numeric(sg_ue.x))

## Base aqui é mais para descrever a situação dos candidatos naoReeleito, novoEleito, novoNaoEleito
##  e reeleitos usando as bases de 2016 e 2020 do TSE.


# Base para pegar os codigos do ibge, tendo em vista que a base do tse tem seus codigos próprios.
cam <- 'https://raw.githubusercontent.com/betafcc/Municipios-Brasileiros-TSE/master/municipios_brasileiros_tse.csv'
mun <- readr::read_csv(cam) %>% dplyr::select(-c('uf', 'nome_municipio', 'capital'))

df <- merg %>% dplyr::left_join(mun, by = c('sg_ue.x'='codigo_tse')) %>%
  dplyr::select(codibge = codigo_ibge, reeleicao)

# Salvar a base de dados completa em data

readr::write_rds(df, 'data/df_reeleitos_20_detalhada.rds')




