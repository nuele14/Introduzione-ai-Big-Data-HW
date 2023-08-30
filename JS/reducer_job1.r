# declaring utility functions
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
  risultato <- list(importo  = 0, count = 0)
  # checking if the month is already in the environment
  if (exists(vendita$mese, envir = env, inherits = FALSE)) {
      # get the current value
      valore_corrente <- get(vendita$mese, envir = env)
      # update the count and the total
      risultato$count <- valore_corrente$count + 1
      risultato$importo <- valore_corrente$importo + vendita$importo
  }
  else {
    # setup the count and the total
    risultato$count <- 1
    risultato$importo <- vendita$importo
  }
  # assign the new value to the month into the environment
  assign(vendita$mese, risultato, envir = env)
}
close(connessione)

# iterating through the months in the environment
# and writing output
for (data in ls(env, all = TRUE)) {
  valore <- get(data, envir = env)
  mese = substring(data, 5, 6)
  anno = substring(data, 1, 4)
  mese_testuale = nomi_mesi[as.numeric(mese)]
  data_formattata = paste(anno, mese_testuale, sep = "-")
    importo = round(valore$importo / valore$count, digits = 2)
  cat(data, "\t", importo ,"\t",data_formattata, "\n", sep = "")
}
