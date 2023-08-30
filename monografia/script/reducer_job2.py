import subprocess
import pandas as pd

nomi_mesi = ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu",
             "Lug", "Ago", "Set", "Ott", "Nov", "Dic"]

nome_file_precedente = subprocess.check_output(['hadoop', 'fs', '-text', '/homework/job1/output/medie_calcolate']).decode('utf-8')
dati_precedenti = pd.read_csv(nome_file_precedente, sep='\t')

env = {}

while True:
    line = input()
    if not line:
        break
    
    valore_linea = line.strip().split("\t")
    vendita = {'data': valore_linea[0], 'importo': float(valore_linea[1])}
    risultato = {'totale': 0, 'count': 0}
    
    if vendita['data'] in env:
        valore_corrente = env[vendita['data']]
        media_del_mese = dati_precedenti[dati_precedenti['data'] == vendita['data']]['media'].values[0]
        risultato['count'] = valore_corrente['count'] + 1
        risultato['totale'] = valore_corrente['totale'] + (vendita['importo'] - dati_precedenti[dati_precedenti['data'] == vendita['data']]['media'].values[0]) ** 2
    else:
        media_del_mese = dati_precedenti[dati_precedenti['data'] == vendita['data']]['media'].values[0]
        risultato['count'] = 1
        risultato['totale'] = (vendita['importo'] - dati_precedenti[dati_precedenti['data'] == vendita['data']]['media'].values[0]) ** 2
    
    env[vendita['data']] = risultato

for data, valore in env.items():
    mese = data[5:7]
    anno = data[0:4]
    mese_testuale = nomi_mesi[int(mese) - 1]
    data_formattata = f"{anno}-{mese_testuale}"
    varianza = round(valore['totale'] / valore['count'], 2)
    print(f"{data}\t{varianza}\t{data_formattata}")
