
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Municípios que não reelegeram seus prefeitos tiveram mais casos de covid19?

<!-- badges: start -->
<!-- badges: end -->

O projeto tem o objetivo de mostrar uma associação entre os casos
confirmados e mortes decorrentes da covid19 e o prefeito não ter sido
reeleito em 2020, ou seja, aqueles que estavam buscando um segundo
mandato. A hipótese noerteadora é que os municípios com prefeitos não
reeleitos foram aqueles com maior associação a quantidade de casos e
mortes notificadas durante a pandemia.

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

-   Então vamos criar uma base de dados que junte essas duas bases
    anteriores, possibilitando que as variáveis de interesses estejam no
    mesmo `data.frame`.

``` r
df_casos <- readr::read_rds('data/dados.rds')
```

-   Os dados foram recortados somente para o estado do Ceará, com as
    variáveis de casos e mortes da covid19 sendo truncadas na data de
    `2020-12-31`, que mostra os quantitativos acumulados de todo ano
    de 2020. Por outro lado, a variável de reeleição é uma *dummy*.
    Portanto, além destas três variáveis principais citadas acima, a
    base `dados` possui mais sete variáveis:

    -   `c_uf`
    -   `codibge`
    -   `city`
    -   `pop19`
    -   `confirmed`
    -   `desths`
    -   `reeleicao`
    -   **`d_reeleicao`**
    -   **`confirmed_100k`**
    -   **`deaths_100k`**

-   O método que será utilizado para ver essa associação entre as
    variáveis será uma regressão simples de mínimos quadrados ordinários
    (MQO).

*y*<sub>*i*</sub> = *α* + *β**x* + *ϵ*

# Análise Descritiva dos Dados

## Análise Gráfica

## Conclusões
