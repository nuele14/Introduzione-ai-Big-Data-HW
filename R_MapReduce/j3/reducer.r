# declaring utility functions
trim_white_space <- function(line) gsub("(^ +)|( +$)", "", line)
split_line <- function(line) {
  val <- unlist(strsplit(line, "\t"))
  list(month = val[1], euro = as.numeric(val[2]))
}

# creating a new environment
env <- new.env(hash = TRUE)
# reading what is in the console
con <- file("stdin", open = "r")
# iterating through the lines
while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
  line <- trim_white_space(line)
  # splitting the line into fields to get a list describing the sale
  sale <- split_line(line)
  # assign the new value to the month into the environment
  # the assigned values is:
  # the sum of old and new value, if the month is already in the environment
  # the new value, otherwise
  assign(sale$month,
    ifelse(exists(sale$month, envir = env, inherits = FALSE),
      get(sale$month, envir = env) + sale$euro,
      sale$euro),
    envir = env)
}

# getting all the months in the environment
months <- ls(env, all = TRUE)
# creating a dataframe to store the months and sum of of their sale amounts
values <- data.frame()
for (month in months) {
  values <- rbind(values, c(month, get(month, envir = env)))
}
colnames(values) <- c("month", "euro")

# iterating through the years
for (year in unique(substring(months, 1, 4))) {
  # filtering all the months in the year
  values_in_year <- values[which(startsWith(values$month, year)), ]
  # getting the month with the highest sale amount
  max <- values_in_year[which.max(values_in_year$euro), ]
  # writing output
  cat(max$month, "\t", max$euro, "\n", sep = "")
}