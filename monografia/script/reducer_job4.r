library(stringr)
nomi_mesi <- c("Gen", "Feb", "Mar", "Apr", "Mag", "Giu",
               "Lug", "Ago", "Set", "Ott", "Nov", "Dic")

env <- new.env(hash = TRUE)

connessione <- file("stdin", open = "r")

while (length(line <- readLines(connessione, n = 1, warn = FALSE)) > 0) {
  valore_linea <- unlist(strsplit(line, "\t"))
  vendita <- list(mese = valore_linea[1], importo = as.numeric(valore_linea[2]))
  risultato = 0
  
  if (exists(vendita$mese, envir = env, inherits = FALSE)) {
      valore_salvato <- get(vendita$mese, envir = env)
      risultato <- valore_salvato + vendita$importo 
  }
  else {
    risultato = vendita$importo
  }
  
  assign(vendita$mese, risultato, envir = env)
}

close(connessione)

chiavi <- ls(env, all = TRUE)
valori <- sapply(chiavi, function(chiave) get(chiave, envir = env))
df <- data.frame(Chiave = chiavi, Valore = valori)
df$anno <- substr(df$Chiave, 1, 4)
df$mese <- substr(df$Chiave, 5, 6)
df$mese_testuale <- nomi_mesi[as.numeric(df$mese)]
df$data_formattata <- paste(df$anno, df$mese_testuale, sep = "-")


lista_anni = unique(df$anno)
for (year in lista_anni) {
  values_in_year <- df[which(df$anno == year), ]
  min <- values_in_year[which.min(values_in_year$Valore), ]
  cat(min$anno, "\t", min$Valore,"\t", min$data_formattata, "\n", sep = "")
}
