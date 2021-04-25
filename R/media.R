


#' Title
#'
#' @param tabela Nome da tabela
#' @param coluna Nome da coluna
#'
#' @return Retorna um número
tirar_media <- function(tabela, coluna){
  mean(tabela[[coluna]], rm.na = TRUE)
}

