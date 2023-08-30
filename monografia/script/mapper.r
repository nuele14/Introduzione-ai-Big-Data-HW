filtro <- c("FATTURA", "RICEVUTA")

connessione <- file("stdin", open = "r")

while (length(line <- readLines(connessione, n = 1, warn = FALSE)) > 0) {
  fields <- unlist(strsplit(line, ","))

  tipoOrdine <- fields[1]
  data <- substr(fields[2], 1, 6)
  costo <- fields[3]
  
  if (tipoOrdine %in% filtro){
    cat(data, "\t", costo, "\n", sep = "")
  }
}
close(connessione)
