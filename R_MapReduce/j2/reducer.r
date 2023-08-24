library(data.table)

# declaring utility functions
trim_white_space <- function(line) gsub("(^ +)|( +$)", "", line)
split_line <- function(line) {
  val <- unlist(strsplit(line, "\t"))
  list(month = val[1], euro = as.numeric(val[2]))
}
calculate_sqm <- function(value, month) {
  return((value - mean_by_month[mean_by_month$V1 == month]$V2)^2)
}

# reading the mean values stored in hdfs calculated by JOB 1
mean_by_month <- fread("hadoop fs -text /prj/j1/output/part-00000")
# creating a new environment
env <- new.env(hash = TRUE)
# reading what is in the console
con <- file("stdin", open = "r")
# iterating through the lines
while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
  line <- trim_white_space(line)
  # splitting the line into fields to get a list describing the sale
  sale <- split_line(line)
  new_value <- list(tot  = 0, count = 0)
  # checking if the month is already in the environment
  if (exists(sale$month, envir = env, inherits = FALSE)) {
      # get the current value
      old_value <- get(sale$month, envir = env)
      # update the count and the summation of the squared differences
      new_value$count <- old_value$count + 1
      new_value$tot <- old_value$tot + calculate_sqm(sale$euro, sale$month)
  } else {
    # setup the count and the total
    new_value$count <- 1
    new_value$tot <- calculate_sqm(sale$euro, sale$month)
  }
  # assign the new value to the month into the environment
  assign(sale$month, new_value, envir = env)
}
close(con)

# iterating through the months in the environment
# and writing output
for (month in ls(env, all = TRUE)) {
  value <- get(month, envir = env)
  cat(month, "\t", toString(value$tot / value$count), "\n", sep = "")
}
