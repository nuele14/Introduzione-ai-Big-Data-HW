import pandas as pd
import sys

def get_month_name(month):
    nomi_mesi = ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu",
                 "Lug", "Ago", "Set", "Ott", "Nov", "Dic"]
    return nomi_mesi[month - 1]

env = {}

for line in sys.stdin:
    valore_linea = line.strip().split("\t")
    vendita = {'mese': valore_linea[0], 'importo': float(valore_linea[1])}
    risultato = 0

    if vendita['mese'] in env:
        valore_salvato = env[vendita['mese']]
        risultato = valore_salvato + vendita['importo']
    else:
        risultato = vendita['importo']
    
    env[vendita['mese']] = risultato

chiavi = list(env.keys())
valori = list(env.values())

df = pd.DataFrame({'Chiave': chiavi, 'Valore': valori})
df['anno'] = df['Chiave'].str[:4]
df['mese'] = df['Chiave'].str[4:6]
df['mese_testuale'] = df['mese'].astype(int).apply(get_month_name)
df['data_formattata'] = df['anno'] + '-' + df['mese_testuale']

lista_anni = df['anno'].unique()

for year in lista_anni:
    values_in_year = df[df['anno'] == year]
    max_value = values_in_year.loc[values_in_year['Valore'].idxmax()]
    print(f"{max_value['anno']}\t{max_value['Valore']}\t{max_value['data_formattata']}")
