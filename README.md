
<!-- README.md is generated from README.Rmd. Please edit that file -->

# meuProJeTo

<!-- badges: start -->
<!-- badges: end -->

O projeto tem o objetivo de mostrar uma associação entre os casos
confirmados e mortes decorrentes da covid19 e o prefeito não ter sido
reeleito em 2020, ou seja, estavam buscando um segundo mandato.

-   A primeira base de dados utilizada será a de casos confirmados e
    mortes relacionadas a pandemia da covid19, da plataforma
    [Brasil.IO](https://brasil.io/dataset/covid19/files/)

``` r
df_casos <- readr::read_rds('data/df_casosCE.rds')
```

-   A segunda base de dados uitlizada será a de candidaturas do
    [Tribunal Superios Eleitoral
    (TSE)](https://www.tse.jus.br/hotsites/pesquisas-eleitorais/candidatos.html),
    dos anos de 2016 e 2020, as quais possibitam saber os prefeitos que
    conseguiram a reeleição ou não.

``` r
df_casos <- readr::read_rds('data/df_naoReeleitoCE.rds')
```

Então vamos criar uma base de dados que junte essas duas bases
anteriores, possibilitando que as variáveis de interesses estejam no
mesmo `data.frame`.

``` r
df_casos <- readr::read_rds('data/dados.rds')
```
