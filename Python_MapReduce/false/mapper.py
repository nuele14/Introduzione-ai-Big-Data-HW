filtro = ["FATTURA", "RICEVUTA"]

# Lettura da console
import sys

for line in sys.stdin:
    fields = line.strip().split(",")

    tipoOrdine = fields[0]
    data = fields[1][:6]
    costo = fields[2]

    # Verifica se il tipo è FATTURA o RICEVUTA
    # e output della stringa
    if tipoOrdine in filtro:
        print(data + "\t" + costo)
