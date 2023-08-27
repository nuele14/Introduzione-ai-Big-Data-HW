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


#JOB3
somma_mesi = aggregate(documenti_vendita$costo, by = list(mesi), FUN = sum)

colnames(somma_mesi) <- c("data","vendite_totali")
somma_mesi$anno <- substr(somma_mesi$data, 1, 4)
anni <- somma_mesi$anno
mesi_max_importo = aggregate(somma_mesi$vendite_totali, by =list(anni), FUN=max)
colnames(mesi_max_importo) <- c("anno_di_riferimento","vendite_totali")
mesi_max = merge(mesi_max_importo, somma_mesi, by="vendite_totali")


#JOB 4
mesi_min_importoonly = aggregate(somma_mesi$vendite_totali, by =list(anni), FUN=min)
colnames(mesi_min_importoonly) <- c("anno_di_riferimento","vendite_totali")
mesi_min = merge(mesi_min_importoonly, somma_mesi, by="vendite_totali")

library(ggplot2)

ggplot(media_mesi, aes(x = data, y = vendite_medie)) +
  geom_bar(stat = "identity", fill = "steelblue", position = position_dodge(width = 0.8)) +
   ggtitle("Medie per Mese") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text = element_text(margin = margin(t = 5, unit = "pt")))