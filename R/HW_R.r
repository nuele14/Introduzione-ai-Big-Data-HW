# Ottieni il percorso del file di script corrente
path_attuale <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(path_attuale)


library(lubridate)
library(dplyr)



#leggo i dati del file
nomeFile="Ordini.csv"
df=read.csv(nomeFile, sep= ",", header= FALSE)
#Aggiungi l’header al dataframe
colnames(df) <- c("tipo","data","costo")
summary(df)
table(df$tipo)

documenti_vendita <- subset(df, tipo=="FATTURA" | tipo=="RICEVUTA")

# getting all the dates in format "YYYYMM"
mesi <- substring(documenti_vendita$data, 1, 6)

#JOB 1
media_mesi <- aggregate(documenti_vendita$costo, by = list(mesi), FUN = mean)
colnames(media_mesi) <- c("data","vendite_medie")



nomi_mesi <- c("Gen", "Feb", "Mar", "Apr", "Mag", "Giu",
               "Lug", "Ago", "Set", "Ott", "Nov", "Dic")

media_mesi <- media_mesi %>%
  mutate(mese = substring(media_mesi$data, 5, 6))
media_mesi$anno <- substr(media_mesi$data, 1, 4)

media_mesi <- media_mesi %>%
  mutate(mese_testuale = nomi_mesi[as.numeric(mese)])

media_mesi <- media_mesi %>%
  mutate(data_formattata = paste(anno, mese_testuale, sep = "-"))

media_mesi <- media_mesi %>%
  select(data ,vendite_medie, data_formattata)



#JOB 2
varianza_mesi = aggregate(documenti_vendita$costo, by = list(mesi), FUN = var)
colnames(varianza_mesi) <- c("data","varianza")
varianza_mesi$anno <- substr(varianza_mesi$data, 1, 4)
varianza_mesi$mese <- substr(varianza_mesi$data, 5, 6)
varianza_mesi <- varianza_mesi %>%
  mutate(mese_testuale = nomi_mesi[as.numeric(mese)])
varianza_mesi <- varianza_mesi %>%
  mutate(data_formattata = paste(anno, mese_testuale, sep = "-"))

varianza_mesi <- varianza_mesi %>%
  select(data ,varianza, data_formattata)
#JOB3
somma_mesi = aggregate(documenti_vendita$costo, by = list(mesi), FUN = sum)

colnames(somma_mesi) <- c("data","vendite_totali")
somma_mesi$anno <- substr(somma_mesi$data, 1, 4)
anni <- somma_mesi$anno
mesi_max_solo_anno = aggregate(somma_mesi$vendite_totali, by =list(anni), FUN=max)
colnames(mesi_max_solo_anno) <- c("anno_di_riferimento","vendite_totali")
mesi_max = merge(mesi_max_solo_anno, somma_mesi, by="vendite_totali")
mesi_max$anno <- substr(mesi_max$data, 1, 4)
mesi_max$mese <- substr(mesi_max$data, 5, 6)
mesi_max <- mesi_max %>%
  mutate(mese_testuale = nomi_mesi[as.numeric(mese)])
mesi_max <- mesi_max %>%
  mutate(data_formattata = paste(anno, mese_testuale, sep = "-"))


#JOB 4
mesi_min_solo_anno = aggregate(somma_mesi$vendite_totali, by =list(anni), FUN=min)
colnames(mesi_min_solo_anno) <- c("anno_di_riferimento","vendite_totali")
mesi_min = merge(mesi_min_solo_anno, somma_mesi, by="vendite_totali")
mesi_min$anno <- substr(mesi_min$data, 1, 4)
mesi_min$mese <- substr(mesi_min$data, 5, 6)
mesi_min <- mesi_min %>%
  mutate(mese_testuale = nomi_mesi[as.numeric(mese)])
mesi_min <- mesi_min %>%
  mutate(data_formattata = paste(anno, mese_testuale, sep = "-"))

library(ggplot2)

media_generale <- mean(media_mesi$vendite_medie)

media_mesi <- media_mesi[order(media_mesi$data),]

media_mesi$data_formattata <- factor(media_mesi$data_formattata, levels = unique(media_mesi$data_formattata))

ggplot(media_mesi, aes(x = data_formattata, y = vendite_medie, group = 1,)) + geom_line() + geom_point() + ggtitle("Medie per Mese") + geom_hline(yintercept = media_generale, color = "red", linetype = "dashed", size = 1) + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + labs(x = "Date", y = " Importo medio (€)")
# da aggiungere per fare vedere la media generale geom_hline(yintercept = valore_linea, linetype = "dashed", color = "red")

ggplot(varianza_mesi, aes(x = data_formattata, y = varianza)) +
  geom_boxplot(fill = "lightblue", color = "darkblue") +
  labs(title = "Box Plot della Varianza",
       y = "Valore della Variabile") +
  theme_minimal()

dati_vendite <- merge(media_mesi, varianza_mesi, by = "data", all = TRUE)

dati_vendite <- dati_vendite[order(dati_vendite$data),]

dati_vendite$data_formattata.x <- factor(dati_vendite$data_formattata.x, levels = unique(dati_vendite$data_formattata.x))

ggplot(dati_vendite, aes(x = data_formattata.x, y = vendite_medie)) +
  geom_boxplot(fill = "lightblue", color = "darkblue") +
  geom_hline(aes(yintercept = mean(vendite_medie)), color = "red", linetype = "dashed", linewidth = 1) +
  geom_errorbar(aes(ymin = vendite_medie - varianza, ymax = vendite_medie + varianza), width = 0.2, color = "blue") +
  labs(title = "Box Plot della Varianza Vendite Mensili",
       x = "Data",
       y = "Varianza") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))



# Calcola la somma degli introiti per ogni anno
fatturato_per_anno <- aggregate(vendite_totali ~ anno, data = somma_mesi, sum)

# Creazione del grafico a torta
ggplot(fatturato_per_anno, aes(x = "", y = vendite_totali, fill = as.factor(anno))) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Fatturato per Anno",
       fill = "Anno") +
  theme_minimal() +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "right")

media_generale <- mean(somma_mesi$vendite_totali)

ggplot(mesi_max, aes(x = data_formattata, y = vendite_totali)) + geom_bar(stat = "identity", fill = "green", position = position_dodge(width = 0.8)) + labs(title = "Miglior mese per anno",
       x = "Data",
       y = "Fatturato") + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + geom_hline(yintercept = media_generale, color = "red", linetype = "dashed", size = 1)

ggplot(mesi_min, aes(x = data_formattata, y = vendite_totali)) + geom_bar(stat = "identity", fill = "blue", position = position_dodge(width = 0.8)) + labs(title = "Peggior mese per anno",
       x = "Data",
       y = "Fatturato")  + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + geom_hline(yintercept = media_generale, color = "red", linetype = "dashed", size = 1)
