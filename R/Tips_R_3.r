#setting working directory and loading libraries
current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path) 3. setwd(current_working_dir)
library(dplyr)

#defining some useful variables
input <- "./ordini.csv"
out_j1 <- "./output/j1.csv"
out_j2 <- "./output/j2.csv"
out_j3 <- "./output/j3.csv"
out_j4 <- "./output/j4.csv"
month_names <- c("Gen", "Feb", "Mar", "Apr", "Mag", "Giu",
"Lug", "Ago", "Set", "Ott", "Nov", "Dic")

if (!dir.exists("./output")) {
dir.create("./output")
}
if (!dir.exists("./plots")) {
dir.create("./plots")
}

# reading input
orders <- read.csv(file = input, header = F, sep = ",")
# adding column names
colnames(orders) <- c("Type", "Date", "Euro")
# filtering
filter_type <- c("FATTURA", "RICEVUTA")
sales <- orders[which(orders$Type %in% filter_type), ]
# getting all the dates in format "YYYYMM"
months <- substring(sales$Date, 1, 6)

# JOB 1: calculating the mean values of each month
mean_by_month <- aggregate(sales$Euro, by = list(months), FUN = mean)
df_mean_by_month <- data.frame(
month=c(paste(substring(mean_by_month[,1],5,6),"-",
substring(mean_by_month[, 1], 1, 4), sep = "")),
value=round(mean_by_month[,2],2))
write.csv(df_mean_by_month, out_j1, row.names = F)

# JOB 2: calculating the var values of each month
variance_by_month <- aggregate(sales$Euro, by = list(months), FUN = var) 42. # 'var' function calculate the sample variance, so the calculated variance 43. # is multiplied by (n-1)/n to obtain population variance
n <- aggregate(sales$Euro, by = list(months), FUN = length)
variance_by_month$x <- variance_by_month$x * (n$x - 1) / n$x
df_variance_by_month <- data.frame(
month=c(paste(substring(variance_by_month[,1],5,6),"-",
substring(variance_by_month[, 1], 1, 4), sep = "")),
value = as.numeric(variance_by_month[, 2]))
write.csv(df_variance_by_month, out_j2, row.names = F)

# calculating the sum of the sale amounts of each month
sum_by_month <- aggregate(sales$Euro, by = list(months), FUN = sum)

# adding the column Year to sum_by_month sum_by_month$Year <- substring(sum_by_month$Group.1, 1, 4)
# JOB 3: found the most profitable month of each year max_month_by_year <- sum_by_month %>%
group_by(Year)%>%
slice(which.max(x)) df_max_month_by_year <- data.frame(
month=c(paste(substring(max_month_by_year$Group.1,5,6),"-", max_month_by_year$Year, sep = "")),
value = as.numeric(max_month_by_year$x)) write.csv(df_max_month_by_year, out_j3, row.names = F)
# JOB 4: found the least profitable month of each year min_month_by_year <- sum_by_month %>%
group_by(Year)%>%
slice(which.min(x)) df_min_month_by_year <- data.frame(
month=c(paste(substring(min_month_by_year$Group.1,5,6),"-", min_month_by_year$Year, sep = "")),
value = as.numeric(min_month_by_year$x)) write.csv(df_min_month_by_year, out_j4, row.names = F)
library(ggplot2) library(patchwork) #function for styling axes custom_axes <-
function(d){ return(d +
}
theme(axis.text = element_text(size = 15),
axis.title = element_text(size = 20, face = "bold"), plot.title = element_text(size = 20, face = "bold")))
# extra (not required)
# let's have a look of the distribution of the monthly sale
# amounts over the years (no 2020 because it's not a full year) png("./plots/monthly_distributions_of_each_year.png", 1600, 800) g1 <- ggplot(sum_by_month, aes(x = substr(Group.1, 1, 4), y = x,
color = substr(Group.1, 1, 4))) + ggtitle("Monthlysalesdistributionovertheyears")+
labs(x="Date",y="Euro")+ scale_color_brewer(palette="Dark2",guide="none")+ theme(panel.background=element_rect(
fill = "white", color = "black", size = 1), panel.grid.major = element_line(
color = "gray10", size = .5, linetype = "dashed" ),
panel.grid.minor = element_line(
color = "gray70", size = .25, linetype = "dashed" )
)
g1 <- custom_axes(g1)
((g1 + geom_boxplot(size = 1)) +
(g1 + geom_violin(fill = "gray80", size = 1.2, alpha = .5) + geom_point(size = 3)))
dev.off()

# extra (not required)
# let's have a look of the differences among the years png("./plots/month_sales_over_years.png", 900, 900) g2 <-
ggplot(sum_by_month[-which(sum_by_month$Year == "2020"), aes(x = as.numeric(substr(Group.1, 5, 6)),
],
y = x,
color = Year)) + ggtitle("Monthly sales over the years")
labs(x = "Month", y = "Sales Amount") + scale_color_brewer(palette = "Dark2") + theme(panel.background = element_rect(
fill = "white", color = "black", size panel.grid.major = element_line(
+
= 1),
color = "gray10", size = .5, linetype = "dashed" ),
panel.grid.minor = element_line(
color = "gray70", size = .25, linetype = "dashed"
) )
g2 <- custom_axes(g2)
g2 + geom_point(size = 2) + geom_line(aes(color = Year)) +
stat_smooth(method = "lm", se = F,
color = "black", size = 1.1) +
stat_smooth(method = "loess", se = F, color = "red", size = 1.1) +
scale_x_discrete(limits = 1:12, breaks = 1:12,
dev.off()
labels = month_names)
# defining function to plot some similar diagrams custom_diagram <-
function(df, file_name, file_width = 1600, file_height = d_title = "Title", d_x_title = "X", d_y_title = use_labels = F) {
png(file_name, file_width, file_height)
l <- length(df$month)
800, "Y",
2)), y =
diag <- ggplot(df, aes(x = as.numeric(substr(month, 1, value)) +
labs(x = d_x_title, y = d_y_title) + ggtitle(d_title) +
theme_minimal() + scale_x_discrete(limits = 1:l,
breaks = 1:l,
labels = month_names[1:l]) + geom_bar(stat = "identity",
color = "black", fill = "blue") + scale_y_continuous(labels = scales::number)
if (use_labels) { diag <- diag +
geom_text(aes(label = value),
color = "black", size = 8, vjust = -.3,
position = position_dodge(.9))
}
diag <- custom_axes(diag) print(diag)
dev.off()
}

# generating diagrams for mean values and variance of each month
for (yearly_means in

split(df_mean_by_month, substring(df_mean_by_month$month, 4, 7))) {
    year <- substring(yearly_means[1, 1], 4, 7)
    custom_diagram(df = yearly_means,
    file_name = paste("./plots/month_means_", year, ".png" ,sep= ""),
    d_title = paste("Monthly Mean Sales Amount - ", year ,sep= ""),
    d_x_title = "Month", d_y_title = "Euro", file_width = 1200, use_labels = T)
}
for (yearly_vars in
split(df_variance_by_month, substring(df_variance_by_month$month, 4, 7))) {
year <- substring(yearly_vars[1, 1], 4, 7) custom_diagram(df = yearly_vars,
file_name = paste("./plots/month_vars_", year, ".png" ,sep= ""),
d_title = paste("Monthly Sales Variance - ", year ,sep= ""),
d_x_title = "Month", d_y_title = "Variance amount", file_width = 1200,
use_labels = F)
}
# generating diagrams for the most and the lest profitable month of each year
df_min_month_by_year$type <- "min"
df_max_month_by_year$type <- "MAX"
df_min_max <- rbind(df_min_month_by_year, df_max_month_by_year)
df_min_max$Year <- substring(df_min_max$month, 4, 7)
df_min_max <- df_min_max[with(df_min_max, order(Year, value)), ]
png("./plots/min_max.png", 1200, 900)
diag <- ggplot(df_min_max, aes(x = Year, y = value, fill = type)) + labs(x = "Month", y = "Euro") +
ggtitle("The most and the lest profitable month of each year") + theme(panel.background = element_rect(
fill = "white", color = "black", size = 1), panel.grid.major = element_line(
color = "gray10", size = .5, linetype = "dashed" ),
panel.grid.minor = element_line(
color = "gray70", size = .25, linetype = "dashed"
),
legend.position = "none" )
diag <- custom_axes(diag)
diag + geom_bar(position = position_dodge(), stat = "identity",
color = "black", size = .5) +
scale_fill_manual(values = c("limegreen", "orangered")) + geom_text(aes(label = month_names[as.numeric(substr(month, 1, 2))]),
vjust = 1.1, color = "black", size = 5,
position = position_dodge(.9)) +
geom_text(aes(label = value, vjust = ifelse(type == "min", -.3, 2.5)),
color = "black", size = 5, position = position_dodge(.9))
dev.off()
# closing all graphics devices
graphics.off()








