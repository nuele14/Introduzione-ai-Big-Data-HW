nomi_mesi = ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu",
             "Lug", "Ago", "Set", "Ott", "Nov", "Dic"]
env = {}
import sys

for line in sys.stdin:
    valore_linea = line.strip().split("\t")
    vendita = {"mese": valore_linea[0], "importo": float(valore_linea[1])}
    risultato = {"importo": 0, "count": 0}

    if vendita["mese"] in env:
        valore_corrente = env[vendita["mese"]]
        risultato["count"] = valore_corrente["count"] + 1
        risultato["importo"] = valore_corrente["importo"] + vendita["importo"]
    else:
        risultato["count"] = 1
        risultato["importo"] = vendita["importo"]
    
    env[vendita["mese"]] = risultato

for data, valore in env.items():
    mese = data[4:6]
    anno = data[0:4]
    mese_testuale = nomi_mesi[int(mese) - 1]
    data_formattata = f"{anno}-{mese_testuale}"
    importo = round(valore["importo"] / valore["count"], 2)
    print(f"{data}\t{importo}\t{data_formattata}")
