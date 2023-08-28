# Dichiarazione delle funzioni di utilità
nomi_mesi = ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu",
             "Lug", "Ago", "Set", "Ott", "Nov", "Dic"]

# Creazione di un nuovo ambiente
env = {}

# Lettura da console
import sys

for line in sys.stdin:
    # Divisione della linea nei campi per ottenere una lista che descrive la vendita
    valore_linea = line.strip().split("\t")
    vendita = {"mese": valore_linea[0], "importo": float(valore_linea[1])}
    risultato = {"importo": 0, "count": 0}

    # Verifica se il mese è già nell'ambiente
    if vendita["mese"] in env:
        # Ottieni il valore corrente
        valore_corrente = env[vendita["mese"]]
        # Aggiorna il conteggio e il totale
        risultato["count"] = valore_corrente["count"] + 1
        risultato["importo"] = valore_corrente["importo"] + vendita["importo"]
    else:
        # Imposta il conteggio e il totale
        risultato["count"] = 1
        risultato["importo"] = vendita["importo"]
    
    # Assegna il nuovo valore al mese nell'ambiente
    env[vendita["mese"]] = risultato

# Itera attraverso i mesi nell'ambiente
# e scrivi l'output
for data, valore in env.items():
    mese = data[4:6]
    anno = data[0:4]
    mese_testuale = nomi_mesi[int(mese) - 1]
    data_formattata = f"{anno}-{mese_testuale}"
    importo = round(valore["importo"] / valore["count"], 2)
    print(f"{data}\t{importo}\t{data_formattata}")
