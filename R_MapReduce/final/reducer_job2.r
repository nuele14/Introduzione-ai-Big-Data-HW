library(data.table)
nomi_mesi <- c("Gen", "Feb", "Mar", "Apr", "Mag", "Giu",
               "Lug", "Ago", "Set", "Ott", "Nov", "Dic")

# declaring utility functions
trim_white_space <- function(line) gsub("(^ +)|( +$)", "", line)
split_line <- function(line) {
  
}
calculate_sqm <- function(value, month) {
  return((value - mean_by_month[mean_by_month$V1 == month]$V2)^2)
}

# prendo la media dal job 1
nome_file_precedente <- "hadoop fs -text /prj/j1/output/medie_calcolate"
dati_precedenti <- fread(nome_file_precedente)
# calcolo somma dei quadrati delle differenze
env <- new.env(hash = TRUE)
connessione <- file("stdin", open = "r")
while (length(line <- readLines(connessione, n = 1, warn = FALSE)) > 0) {
  
  valore_linea <- unlist(strsplit(line, "\t"))
  vendita <- list(data = valore_linea[1], importo = as.numeric(valore_linea[2]))
  risultato <- list(totale  = 0, count = 0)
  
  if (exists(vendita$data, envir = env, inherits = FALSE)) {
      valore_corrente <- get(vendita$data, envir = env)
      # quadrati delle differenze incrementali
      risultato$count <- valore_corrente$count + 1
      media_del_mese <- dati_precedenti[dati_precedenti$V1 == vendita$data]$V2
      risultato$totale <- (valore_corrente$totale + (vendita$importo - media_del_mese)^2)
  } else {
    risultato$count <- 1
    media_del_mese <- dati_precedenti[dati_precedenti$V1 == vendita$data]$V2
    risultato$totale <- ((vendita$importo - media_del_mese)^2)
  }
  # salvo risutato temporaneo
  assign(vendita$data, risultato, envir = env)
}
close(connessione)


# media dei quadrati delle differenze
for (data in ls(env, all = TRUE)) {
  valore <- get(data, envir = env)
  mese = substring(data, 5, 6)
  anno = substring(data, 1, 4)
  mese_testuale = nomi_mesi[as.numeric(mese)]
  data_formattata = paste(anno, mese_testuale, sep = "-")
  varianza = round(valore$totale / valore$count, digits = 2)
  cat(data, "\t", varianza ,"\t",data_formattata, "\n", sep = "")
}
