# Ottieni il percorso del file di script corrente

# Imposta la directory di lavoro sulla directory del file di script
setwd()


#leggo i dati del file
nomeFile="Ordini.csv"
df=read.csv(nomeFile, sep= ",", header= FALSE)
#Aggiungi l’header al dataframe
colnames(df) <- c("tipo","data","costo")
summary(df)
# adding column names
table(df$tipo)

doucmenti_vendita <- subset(df, tipo=="FATTURA" | tipo=="RICEVUTA")

# getting all the dates in format "YYYYMM"
mesi <- substring(doucmenti_vendita$Date, 1, 6)



