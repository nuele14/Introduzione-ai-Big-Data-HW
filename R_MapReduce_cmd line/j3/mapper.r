# declaring utility functions
trim_white_space <- function(line) gsub("(^ +)|( +$)", "", line)
split_into_fields <- function(line) unlist(strsplit(line, ","))
filter_type <- c("FATTURA", "RICEVUTA")

# reading what is in the console
con <- file("stdin", open = "r")
# iterating through the lines
while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
  line <- trim_white_space(line)
  # splitting the line into fields
  fields <- split_into_fields(line)

  # checking if the type is FATTURA or RICEVUTA
  # and output string
  if (fields[1] %in% filter_type)
    cat(substr(fields[2], 1, 6), "\t", fields[3], "\n", sep = "")
}
close(con)
