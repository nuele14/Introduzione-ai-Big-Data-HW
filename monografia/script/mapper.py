filtro = ["FATTURA", "RICEVUTA"]
import sys

for line in sys.stdin:
    fields = line.strip().split(",")
    
    tipoOrdine = fields[0]
    data = fields[1][:6]
    costo = fields[2]
    
    if tipoOrdine in filtro:
        print(data + "\t" + costo)
