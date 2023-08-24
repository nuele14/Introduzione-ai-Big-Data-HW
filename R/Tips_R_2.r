# Importo il file csv
ordini <- read.csv("/Users/giorgianesci/Documents/Uninettuno/Introduzioneai Big Data/Progetto Nesci/Ordini.csv", sep= ",", header= FALSE)

#Imposto l'intestazione per le colonne
colnames(ordini) <- c('Tipo', 'Data', 'Prezzo')

#Conto la quantità di documenti per ogni tipologie
table(ordini$Tipo)


# Selezione degli oggetti di tipo "FATTURA" e "RICEVUTA"
ricavi <- subset(ordini, Tipo=="FATTURA" | Tipo=="RICEVUTA")
# Fatturato medio di ogni mese di ogni anno
media_mesi = aggregate(ricavi$Prezzo, by = list(substr(ricavi[,2], 1,6)), FUN=mean)

# Rinomino intestazioni colonne media_mesi
colnames(media_mesi)[1] <- 'Mesi'
colnames(media_mesi)[2] <- 'Fatturato_medio'

# File di output job1 23.


# Grafico andamento guadagni in base alla media di ogni mese
write.table(media_mesi,"/Users/giorgianesci/Documents/Uninettuno/Introduzione ai Big Data/ProgettoNesci/Ordini_media_mesi.csv", row.names=FALSE, sep=";" )
barplot(height=media_mesi$Fatturato_medio, main = 'Media mensile divendita', cex.names = 1, axis.lty=1, las=2,xlab = '', ylab = "Fatturatomedio", names.arg=c("Gen2016","Feb2016","Mar2016","Apr2016","Mag2016","Giu2016", "Lug2016", "Ago2016", "Set2016", "Ott2016", "Nov2016","Dic2016", "Gen2017","Feb2017","Mar2017","Apr2017","Mag2017", "Giu2017","Lug2017", "Ago2017", "Set2017", "Ott2017", "Nov2017","Dice2017","Gen2018","Feb2018","Mar2018","Apr2018","Mag2018", "Giu2018","Lug2018", "Ago2018", "Set2018", "Ott2018", "Nov2018", "Dic2018","Gen2019","Feb2019","Mar2019","Apr2019","Mag2019", "Giu2019", "Lug2019","Ago2019", "Set2019", "Ott2019", "Nov2019", "Dic2019","Gen2020","Feb2020","Mar2020","Mag2020", "Giu2020", "Lug2020", "Ago2020"),col="#69b3a2")
# Varianza di vendita di ogni mese di ogni anno
varianza_mesi = aggregate(ricavi$Prezzo, by = list(substr(ricavi[,2], 1,6)), FUN=var)

# Rinomino intestazione colonne varianza_mesi
colnames(varianza_mesi)[1] <- 'Mesi'
colnames(varianza_mesi)[2] <- 'Varianza'

# File di output job2

# Grafico varianza_mesi 41.
write.table(varianza_mesi,"/Users/giorgianesci/Documents/Uninettuno/Introduzione ai Big Data/Progetto Nesci/Ordini_varianza_mesi.csv",row.names=FALSE, sep=";" )barplot(height=varianza_mesi$Varianza, main = 'Varianza mensile divendita', cex.names = 1, axis.lty=1, las=2,xlab = '', ylab = "",names.arg=c("Gen2016","Feb2016","Mar2016","Apr2016","Mag2016", "Giu2016","Lug2016", "Ago2016", "Set2016", "Ott2016", "Nov2016", "Dic2016","Gen2017","Feb2017","Mar2017","Apr2017","Mag2017", "Giu2017", "Lug2017","Ago2017", "Set2017", "Ott2017", "Nov2017","Dic2017","Gen2018","Feb2018","Mar2018","Apr2018","Mag2018", "Giu2018","Lug2018", "Ago2018", "Set2018", "Ott2018", "Nov2018", "Dic2018","Gen2019","Feb2019","Mar2019","Apr2019","Mag2019", "Giu2019", "Lug2019","Ago2019", "Set2019", "Ott2019", "Nov2019", "Dic2019","Gen2020","Feb2020","Mar2020","Mag2020", "Giu2020", "Lug2020", "Ago2020"),col="#7FFFD4")

# Fatturato totale di ogni mese di ogni anno
somma_mesi = aggregate(ricavi$Prezzo, by = list(substr(ricavi[,2], 1,6)), FUN=sum)


# Rinomino intestazione colonne somma_mesi
colnames(somma_mesi)[1] <- 'Mesi'
colnames(somma_mesi)[2] <- 'Fatturato_totale'

# File Output somma_mesi


# Andamento fatturato
write.table(somma_mesi,"/Users/giorgianesci/Documents/Uninettuno/Introduzione ai Big Data/Progetto Nesci/Ordini_somma_mesi.csv", row.names=FALSE,sep=";" )
barplot(height=somma_mesi$Fatturato_totale, main = 'Andamento fatturatodal 01/2016 al 08/2020', cex.names = 1, axis.lty=1, las=2,xlab = '', ylab ="", names.arg=c("Gen2016","Feb2016","Mar2016","Apr2016","Mag2016","Giu2016", "Lug2016", "Ago2016", "Set2016", "Ott2016", "Nov2016","Dic2016", "Gen2017","Feb2017","Mar2017","Apr2017","Mag2017", "Giu2017","Lug2017", "Ago2017", "Set2017", "Ott2017", "Nov2017","Dic2017","Gen2018","Feb2018","Mar2018","Apr2018","Mag2018", "Giu2018","Lug2018", "Ago2018", "Set2018", "Ott2018", "Nov2018", "Dic2018","Gen2019","Feb2019","Mar2019","Apr2019","Mag2019", "Giu2019", "Lug2019","Ago2019", "Set2019", "Ott2019", "Nov2019", "Dic2019","Gen2020","Feb2020","Mar2020","Mag2020", "Giu2020", "Lug2020", "Ago2020"),col="#ADD8E6")
par(mar=c(5, 5, 5, 5)) 59.

# Importo mensile massimo di ogni anno
mesi_max_importoonly = aggregate(somma_mesi$Fatturato_totale, by =list(substr(somma_mesi[,1], 1, 4)), FUN=max)


# Rinomino intestazione colonne mesi_max_importoonly
colnames(mesi_max_importoonly)[1] <- 'Anno'
colnames(mesi_max_importoonly)[2] <- "Fatturato_totale"


mesi_max = merge(mesi_max_importoonly, somma_mesi,by="Fatturato_totale")

# Rinomino la prima colonna di mesi_max
colnames(mesi_max)[1] <- 'Fatturato_mensile_max'


# Rappresentazione grafica "Fatturato mensile massimo per ogni anno"
barplot (height = mesi_max$Fatturato_mensile_max, main = 'Fatturato
mensile massimo per ogni anno', xlab = 'Anni', ylab = 'Fatturato massimo',
names.arg=c("Giugno 2020","Aprile 2018","Ottobre 2019","Dicembre
2016","Giugno 2017"), col = '#834966')
par(mar=c(5, 5, 5, 5)) 79.
# File di output job3
83.
# Importo mensile minimo di ogni anno
mesi_min_importoonly = aggregate(somma_mesi$Fatturato_totale, by =
list(substr(somma_mesi[,1], 1, 4)), FUN=min)


# Rinomino intestazione colonne mesi_min_importoonly
colnames(mesi_min_importoonly)[1] <- 'Anno'
colnames(mesi_min_importoonly)[2] <- "Fatturato_totale"


mesi_min = merge(mesi_min_importoonly, somma_mesi, by =
'Fatturato_totale')

# Rinomino la prima colonna di mesi_min
colnames(mesi_min)[1] <- 'Fatturato_mensile_min'

# Rappresentazione grafica "Fatturato mensile minimo per ogni anno"
. par(mar=c(5, 5, 5, 5)) 101.
.
.
. # File di output job4 105.
write.table(mesi_max,"/Users/giorgianesci/Documents/Uninettuno/Introduzi
one ai Big Data/Progetto Nesci/Ordini_mesi_max.csv", row.names=FALSE,
sep=";" )
barplot (height = mesi_min$Fatturato_mensile_min, main = 'Fatturato
mensile minimo per ogni anno', xlab = 'Anni', ylab = 'Fatturato minimo',
names.arg=c("Agosto 2016","Agosto 2018","Marzo 2020","Agosto
2017","Febbraio 2019"), col = '#79fcca')
write.table(mesi_min,"/Users/giorgianesci/Documents/Uninettuno/Introduzi
one ai Big Data/Progetto Nesci/Ordini_mesi_min.csv", row.names=FALSE,
sep=";" )
