
filtro <- c("FATTURA", "RICEVUTA")

# reading what is in the console
connessione <- file("stdin", open = "r")
# iterating through the lines
while (length(line <- readLines(connessione, n = 1, warn = FALSE)) > 0) {
  # splitting the line into fields
  fields <- unlist(strsplit(line, ","))

  tipoOrdine = fields[1]
  data <- substr(fields[2], 1, 6)
  costo <- fields[3]

  # checking if the type is FATTURA or RICEVUTA
  # and output string
  if (tipoOrdine %in% filtro){
    cat(data, "\t", costo, "\n", sep = "")
  }
}
close(connessione)
