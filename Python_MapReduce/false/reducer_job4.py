import pandas as pd

# Definizione dei nomi dei mesi
nomi_mesi = ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu",
             "Lug", "Ago", "Set", "Ott", "Nov", "Dic"]

# Creazione di un nuovo dizionario
env = {}

# Lettura da console
import sys

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

# Creazione del DataFrame
chiavi = list(env.keys())
valori = list(env.values())

df = pd.DataFrame({'Chiave': chiavi, 'Valore': valori})
df['anno'] = df['Chiave'][:4]
df['mese'] = df['Chiave'][4:6]
df['mese_testuale'] = df['mese'].apply(lambda mese: nomi_mesi[int(mese) - 1])
df['data_formattata'] = df['anno'] + '-' + df['mese_testuale']

lista_anni = df['anno'].unique()

# Stampa del DataFrame
for year in lista_anni:
    values_in_year = df[df['anno'] == year]
    min_value = values_in_year.loc[values_in_year['Valore'].idxmin()]
    print(f"{min_value['anno']}\t{min_value['Valore']}\t{min_value['data_formattata']}")
