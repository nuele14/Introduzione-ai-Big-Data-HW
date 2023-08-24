# Leggi il file CSV utilizzando la funzione read.csv()
dati <- read.csv(“Ordini.csv”)
#Stampa un riassunto statistico del dataframe.
summary(dati)
#Aggiungi l’header al dataframe
colnames(dati) <- c("TIPODOCUMENTO","DATA","COSTO")
# Filtra il dataframe per TIPODOCUMENTO uguale a "FATTURA" o "RICEVUTA"
dati_filtrati <- dati[dati$TIPODOCUMENTO %in% c("FATTURA", "RICEVUTA"), ]
# Converti la colonna "DATA" nel formato corretto
dati_filtrati $DATA <- ymd(dati_filtrati $DATA)
# Aggiungi la colonna "ANNOMESE" al dataset
dati_filtrati <- dati_filtrati %>% mutate(ANNOMESE = format(DATA, "%Y-%m"))
# Calcola la media per ogni mese di ogni anno
media_per_mese <- dati_filtrati %>% group_by(ANNOMESE) %>%
summarise(MEDIA = mean(COSTO))
#Grafico per visualizzare le medie di ogni mese per ogni anno.
grafico <- ggplot(media_per_mese, aes(x = ANNOMESE, y = MEDIA)) +
geom_bar(stat = "identity", fill = "steelblue", position = position_dodge(width = 0.8)) +
labs(x = "ANNOMESE", y = "COSTO") + ggtitle("Medie per Mese") +
theme_minimal() +
theme(axis.text.x = element_text(angle = 90, hjust = 1),
axis.text = element_text(margin = margin(t = 5, unit = "pt")))
#Calcolo varianza per ogni mese di ogni anno.
varianza_per_mese <- dati_filtrati %>% group_by(ANNOMESE) %>%
summarise(VARIANZA = var(COSTO))
#Grafico per visualizzare le varianze di ogni mese per ogni anno.
graficoVarianza <- ggplot(varianza_per_mese, aes(x = ANNOMESE, y = VARIANZA))
geom_bar(stat = "identity", fill = "yellow", color = "black", width = 0.8) +
labs(x = "ANNOMESE", y = "VARIANZA") +
ggtitle("Varianza per Mese") +
theme_minimal() +
theme(axis.text.x = element_text(angle = 90, hjust = 1),
axis.text = element_text(margin = margin(t = 5, unit = "pt")))
#Viene calcolato la somma delle vendite di ogni mese per ogni anno. 23. somma_per_mese <- dati_filtrati %>%
group_by(ANNOMESE) %>%
summarise(SOMMA = sum(COSTO))
# Trova il mese con le vendite più alte per ogni anno 26. mese_max <- somma_per_mese %>%
group_by(substring(ANNOMESE, 1, 4)) %>% 28. top_n(1, SOMMA)
# Trova il mese con le vendite più basse per ogni anno 29. mese_min <- somma_per_mese %>%
group_by(substring(ANNOMESE, 1, 4)) %>% 31. top_n(-1, SOMMA)
# Grafico max vendite mese di ogni anno
grafico_max <- ggplot(mese_max, aes(x = ANNOMESE, y = SOMMA))
geom_bar(stat = "identity", fill = "orange", position = position_dodge(width = 0.8))
labs(x = "ANNOMESE", y = "VENDITE")
ggtitle("Mese con vendite più alte per anno")
theme_minimal()
theme(axis.text.x = element_text(angle = 90, hjust = 1),
axis.text = element_text(margin = margin(t = 5, unit = "pt")))
#Grafico min vendite mese di ogni anno
grafico_min <- ggplot(mese_min, aes(x = ANNOMESE, y = SOMMA))
geom_bar(stat = "identity", fill = "orange", position = position_dodge(width = 0.8))
labs(x = "ANNOMESE", y = "VENDITE")
ggtitle("Mese con vendite più basse per anno")
theme_minimal()
theme(axis.text.x = element_text(angle = 90, hjust = 1),
axis.text = element_text(margin = margin(t = 5, unit = "pt")))