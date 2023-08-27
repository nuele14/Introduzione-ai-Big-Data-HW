library(stringr)
nomi_mesi <- c("Gen", "Feb", "Mar", "Apr", "Mag", "Giu",
               "Lug", "Ago", "Set", "Ott", "Nov", "Dic")

# creating a new environment
env <- new.env(hash = TRUE)
# reading what is in the console
connessione <- file("stdin", open = "r")
# iterating through the lines
while (length(line <- readLines(connessione, n = 1, warn = FALSE)) > 0) {
  # splitting the line into fields to get a list describing the vendita
  valore_linea <- unlist(strsplit(line, "\t"))
  vendita <- list(mese = valore_linea[1], importo = as.numeric(valore_linea[2]))
  risultato = 0
  # checking if the month is already in the environment
  if (exists(vendita$mese, envir = env, inherits = FALSE)) {
      # get the current value
      valore_salvato <- get(vendita$mese, envir = env)
      # update the count and the total
      risultato <- valore_salvato + vendita$importo 
  }
  else {
    # setup the count and the total
    risultato = vendita$importo
  }
  # assign the new value to the month into the environment
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
#df <- df %>% select(Chiave ,Valore, data_formattata, anno)


lista_anni = unique(df$anno)
# Stampa del dataframe
for (year in lista_anni) {
  # filtering all the months in the year
  values_in_year <- df[which(df$anno == year), ]
  # getting the month with the highest sale amount
  max <- values_in_year[which.max(values_in_year$Valore), ]
  # writing output
  cat(max$anno, "\t", max$Valore,"\t", max$data_formattata, "\n", sep = "")
}
