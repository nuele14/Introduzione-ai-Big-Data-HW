library(rmr2)
## map function
map <- function(k,lines) {
  words.list <- strsplit(lines, '\\s')
  words <- unlist(words.list)
  keyval(words, 1)
}
## reduce function
reduce <- function(word, counts) {
  keyval(word, sum(counts))
}
wordcount <- function (input, output=NULL) { mapreduce(input=input, output=output, input.format="text", map=map, reduce=reduce)
}