# declaring utility functions


# creating a new environment
env <- new.env(hash = TRUE)
# reading what is in the console
con <- file("stdin", open = "r")
# iterating through the lines
while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
   valore_linea <- unlist(strsplit(line, "\t"))
  vendita <- list(data = valore_linea[1], importo = as.numeric(valore_linea[2]))
  # assign the new value to the month into the environment
  # the assigned values is:
  # the sum of old and new value, if the month is already in the environment
  # the new value, otherwise
  assign(vendita$data,
    ifelse(exists(vendita$data, envir = env, inherits = FALSE),
      get(vendita$data, envir = env) + vendita$importo,
      vendita$importo),
    envir = env)
}

medie_mesi <- ls(env, all = TRUE)
# creating a dataframe to store the months and sum of of their sale amounts
risultato <- data.frame()
for (data_di_riferimento in medie_mesi) {
  risultato <- rbind(risultato, c(data_di_riferimento, get(data_di_riferimento, envir = env)))
}
colnames(risultato) <- c("data", "importo")

# iterating through the years
for (anno in unique(substring(medie_mesi, 1, 4))) {
  # filtering all the months in the year
  valori_per_anno <- risultato[which(startsWith(risultato$data, anno)), ]
  # getting the month with the highest sale amount
  max <- valori_per_anno[which.max(valori_per_anno$importo), ]
  # writing output
  cat(max$data, "\t", max$importo, "\n", sep = "")
}