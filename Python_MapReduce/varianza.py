# programma per gestione contabilità # autore Marco La Ventura
# università Uninettuno
# matricola: 627HHHINGINFOR
import csv
import statistics
import numpy
import math
import datetime
def popolaRecord(anno,ListaMese,mesedesc,mese, importo):
    record = []
    if not ListaMese:
        impApp = []
        impApp.append(importo)
        record.insert(0, anno)
        record.insert(1, mesedesc)
        record.insert(2, impApp)
        record.insert(3, 1)
        record.insert(4, mese)
    else:
        # Mese esiste
        try:
            if str(ListaMese[anno,mesedesc][1]) == str(mesedesc):
                valueIF=True
        except:
            valueIF=False
        if valueIF:
            #if str(mesedesc) in str(ListaMese[anno,mesedesc][1]):
            impApp=ListaMese[anno,mesedesc][2]
            impApp.append(importo)
            valueMax = ListaMese[anno,mesedesc][3] + 1
            record.insert(0, anno)
            record.insert(1, mesedesc)
            record.insert(2, impApp)
            record.insert(3, valueMax)
            record.insert(4, mese)
        else:
            impApp = []
            impApp.append(importo)
            record.insert(0, anno)
            record.insert(1, mesedesc)
            record.insert(2, impApp)
            record.insert(3, 1)
            record.insert(4, mese)
    return record

def estraimediaMese(anno,mese,importo,listaMese): # dizionario listaMese
    record = []
    if mese == "1":
        mesedesc = "Gennaio"
        mese= mese.rjust(2, '0')
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc,mese, importo)
        listaMese[anno, mesedesc]
    if mese == "2":
        mesedesc = "Febbraio"
        mese= mese.rjust(2, '0')
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc,mese, importo)
    if mese == "3":
        mesedesc = "Marzo"
        mese= mese.rjust(2, '0')
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc,mese, importo)
    if mese == "4":
        mesedesc = "Aprile"
        mese= mese.rjust(2, '0')
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc, mese, importo)
    if mese == "5":
        mesedesc = "Maggio"
        mese= mese.rjust(2, '0')
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc, mese, importo)
        
    if mese == "6":
        mesedesc = "Giugno"
        mese= mese.rjust(2, '0')
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc, mese, importo)
    if mese == "7":
        mesedesc = "Luglio"
        mese= mese.rjust(2, '0')
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc,mese, importo)
    if mese == "8":
        mesedesc = "Agosto"
        mese= mese.rjust(2, '0')
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc, mese, importo)
    if mese == "9":
        mesedesc = "Settembre"
        mese= mese.rjust(2, '0')
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc, mese, importo)
    if mese == "10":
        mesedesc = "Ottobre"
        mese= mese.rjust(2, '0')
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc,mese, importo)
    if mese == "11":
        mesedesc = "Novembre"
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc, mese, importo)
    if mese == "12":
        mesedesc = "Dicembre"
        listaMese[anno,mesedesc] = popolaRecord(anno,listaMese, mesedesc,mese, importo)
        
    return listaMese

def converti_anno(datadoc):
    format = '%Y%m%d'
    datetime = datetime.datetime.strptime(datadoc, format)
    return datetime

def lettura_file(file_csv):
    risultato = open(file_csv,'r')
    file = csv.reader(risultato)
    return file


def main():
    media = []
    #file contenente gli ordini
    file_csv = "/home/hadoop/Ordini.csv"
    file = lettura_file(file_csv)
    rows = []
    totale=0
    n_fattura=0
    tipologia=""
    datadoc=""
    listaMese={}
    for rows in file:
        tipologia = str(rows[0])
        datadoc = str(rows[1])
        datadoc = converti_anno(datadoc)
        importo = float(rows[2])
        if (tipologia == 'FATTURA'):
            ### ciclo i mesi
            estraimediaMese(str(datadoc.year),str(datadoc.month),importo,listaMese)
    x = numpy.array(file)
    arrayannomese = numpy.unique(x) # Calcolo Varianza
    mesecont=1
    annoprec=0
    for lista in listaMese:   
        anno=listaMese[lista][0]
        if (int(anno)!=annoprec):
            mesecont=1
            annoprec=int(anno)      
        if (mesecont !=int(listaMese[lista][4])):
            # trovato mese null - verifico i successivi
            varianza=0
            mesecont = str(mesecont)
            mesecont = mesecont.rjust(2,'0')
            print (f"{anno}{mesecont}{varianza}")
            mesecont = int(mesecont)
            mesecont+=1
            for check in range(mesecont, 12):
                if (check !=int(listaMese[lista][4])):
                    varianza=0
                    mesecont = str(mesecont)
                    mesecont = mesecont.rjust(2,'0')
                    print (f"{anno}{mesecont} {varianza}")
                    mesecont = int(mesecont)
                else:
                    recordVar=listaMese[lista][2]
                    totale = round(sum(recordVar),2)
                    varianza=round(statistics.variance(recordVar),2)
                    print (f"{anno}{listaMese[lista][4]}{varianza}")
                    meseprec = listaMese[lista][4]
                    mesecont += 1
                break
        else:
            recordVar=listaMese[lista][2]
            totale = round(sum(recordVar),2)
            varianza=round(statistics.variance(recordVar),2)
            print (f"{anno}{listaMese[lista][4]} {varianza}")
            meseprec = listaMese[lista][4]
            mesecont += 1 
            
if __name__ == "__main__":
    main()