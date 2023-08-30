nomi_mesi <- c("Gen", "Feb", "Mar", "Apr", "Mag", "Giu",
               "Lug", "Ago", "Set", "Ott", "Nov", "Dic")

env <- new.env(hash = TRUE)

connessione <- file("stdin", open = "r")

while (length(line <- readLines(connessione, n = 1, warn = FALSE)) > 0) {
  valore_linea <- unlist(strsplit(line, "\t"))
  vendita <- list(mese = valore_linea[1], importo = as.numeric(valore_linea[2]))
  risultato <- list(importo  = 0, count = 0)

  if (exists(vendita$mese, envir = env, inherits = FALSE)) {
      valore_corrente <- get(vendita$mese, envir = env)
      risultato$count <- valore_corrente$count + 1
      risultato$importo <- valore_corrente$importo + vendita$importo
  }
  else {
    risultato$count <- 1
    risultato$importo <- vendita$importo
  }

  assign(vendita$mese, risultato, envir = env)
}
close(connessione)

for (data in ls(env, all = TRUE)) {
  valore <- get(data, envir = env)
  mese = substring(data, 5, 6)
  anno = substring(data, 1, 4)
  mese_testuale = nomi_mesi[as.numeric(mese)]
  data_formattata = paste(anno, mese_testuale, sep = "-")
    importo = round(valore$importo / valore$count, digits = 2)
  cat(data, "\t", importo ,"\t",data_formattata, "\n", sep = "")
}
