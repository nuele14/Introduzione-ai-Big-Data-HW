#MAPPER

# declaring utility functions
trim_white_space <- function(line) gsub("(^ +)|( +$)", "", line)
split_into_fields <- function(line) unlist(strsplit(line, ","))
filter_type <- c("FATTURA", "RICEVUTA")

# reading what is in the console
con <- file("stdin", open = "r")
# iterating through the lines
while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
line<-trim_white_space(line)
#splittingthelineintofields
fields<-split_into_fields(line)
#checkingifthetypeisFATTURAorRICEVUTA
#and output string
if(fields[1]%in%filter_type)
cat(substr(fields[2], 1, 6), "\t", fields[3], "\n", sep = "") 18. }
close(con)


#REDUCER 1
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
line<-trim_white_space(line)
#splittingthelineintofieldstogetalistdescribingthesale
sale<-split_line(line)
new_value <- list(tot = 0, count = 0)
#checkingifthemonthisalreadyintheenvironment
if(exists(sale$month,envir=env,inherits=FALSE)){
# get the current value
old_value <- get(sale$month, envir = env)
# update the count and the total
new_value$count <- old_value$count + 1
new_value$tot <- old_value$tot + sale$euro
} else{
# setup the count and the total
new_value$count <- 1
new_value$tot <- sale$euro
} #assignthenewvaluetothemonthintotheenvironment
assign(sale$month,new_value,envir=env)
} close(con)
# iterating through the months in the environment # and writing output
for (month in ls(env, all = TRUE)) {
value<-get(month,envir=env)
cat(month,"\t",value$tot/value$count,"\n",sep="")
}



#REDUCER 2
library(data.table)
# declaring utility functions
trim_white_space <- function(line) gsub("(^ +)|( +$)", "", line) split_line <- function(line) {
val <- unlist(strsplit(line, "\t"))
list(month = val[1], euro = as.numeric(val[2])) }
calculate_sqm <- function(value, month) { return((value-mean_by_month[mean_by_month$V1==month]$V2)^2)
}
# reading the mean values stored in hdfs calculated by JOB 1 mean_by_month <- fread("hadoop fs -text /prj/j1/output/part-00000") # creating a new environment
env <- new.env(hash = TRUE)
# reading what is in the console
con <- file("stdin", open = "r")
# iterating through the lines
while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
line<-trim_white_space(line) #splittingthelineintofieldstogetalistdescribingthesale sale<-split_line(line)
new_value <- list(tot = 0, count = 0) #checkingifthemonthisalreadyintheenvironment if(exists(sale$month,envir=env,inherits=FALSE)){
# get the current value
old_value <- get(sale$month, envir = env)
# update the count and the summation of the squared differences new_value$count <- old_value$count + 1
new_value$tot <- old_value$tot + calculate_sqm(sale$euro, sale$month)
}else{
# setup the count and the total
new_value$count <- 1
new_value$tot <- calculate_sqm(sale$euro, sale$month)
} #assignthenewvaluetothemonthintotheenvironment assign(sale$month,new_value,envir=env)
} close(con)
# iterating through the months in the environment # and writing output
for (month in ls(env, all = TRUE)) {
value<-get(month,envir=env)
cat(month,"\t",toString(value$tot/value$count),"\n",sep="") }




#REDUCER 3
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
line<-trim_white_space(line)
#splittingthelineintofieldstogetalistdescribingthesale
sale<-split_line(line)
#assignthenewvaluetothemonthintotheenvironment
#theassignedvaluesis:
#thesumofoldandnewvalue,ifthemonthisalreadyintheenvironment
#thenewvalue,otherwise
assign(sale$month,
ifelse(exists(sale$month, envir = env, inherits = FALSE), 23. get(sale$month, envir = env) + sale$euro,
sale$euro),
envir = env)
}

# getting all the months in the environment
months <- ls(env, all = TRUE)
# creating a dataframe to store the months and sum of of their sale amounts 31. values <- data.frame()
for (month in months) {
values<-rbind(values,c(month,get(month,envir=env)))
}
colnames(values) <- c("month", "euro")

# iterating through the years
for (year in unique(substring(months, 1, 4))) {
#filteringallthemonthsintheyear
values_in_year<-values[which(startsWith(values$month,year)),]
#gettingthemonthwiththehighestsaleamount
max<-values_in_year[which.max(values_in_year$euro),]
#writingoutput
cat(max$month,"\t",max$euro,"\n",sep="")
}


#REDUCER 4
# Per il codice di j4/reducer.r fare riferimento a j3/reducer.r da riga 1 a riga 36.
# Il codice di j4/reducer.r continua come segue.
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
line<-trim_white_space(line)
#splittingthelineintofieldstogetalistdescribingthesale
sale<-split_line(line)
#assignthenewvaluetothemonthintotheenvironment
#theassignedvaluesis:
#thesumofoldandnewvalue,ifthemonthisalreadyintheenvironment
#thenewvalue,otherwise
assign(sale$month,
ifelse(exists(sale$month, envir = env, inherits = FALSE), 23. get(sale$month, envir = env) + sale$euro,
sale$euro),
envir = env)
}

# getting all the months in the environment
months <- ls(env, all = TRUE)
# creating a dataframe to store the months and sum of of their sale amounts 31. values <- data.frame()
for (month in months) {
values<-rbind(values,c(month,get(month,envir=env)))
}
colnames(values) <- c("month", "euro")
# iterating through the years
for (year in unique(substring(months, 1, 4))) {
#filteringallthemonthsintheyear
values_in_year<-values[which(startsWith(values$month,year)),] 41. #gettingthemonthwiththelowestsaleamount
min<-values_in_year[which.min(values_in_year$euro),]
#writingoutput
cat(min$month,"\t",min$euro,"\n",sep="")
}