hdfs.root <- 'wordcount'
hdfs.data <- file.path(hdfs.root, 'data')
hdfs.out <- file.path(hdfs.root, 'out')

out <- wordcount(hdfs.data, hdfs.out)

results <- from.dfs(out)

results.df <- as.data.frame(results, stringsAsFactors=F)
colnames(results.df) <- c('word', 'count')
head(results.df[order(results.df$count, decreasing=T), ], 30)