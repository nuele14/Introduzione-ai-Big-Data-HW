#!/usr/bin/env python
# Marco La Ventura
# Matricola: 627HHHINGINFOR # mapper per calacolo varianza
import sys
record = []
listrecord = {}
count =0
for line in sys.stdin:
    # to remove leading and trailing whitespace line = line.strip()
    # split the line into words
    words = line.split(",")
    tipologia=words[0]
    data=words[1] 
    importo=words[2]
    if (tipologia=="FATTURA"):
        Kmap=data[0:6]
        Vmap=float(importo)
        record.insert(0,Kmap)
        record.insert(1,Vmap)
        listrecord[count] = record
        count+=1
        record=[]
unique_list = []
for x in listrecord:
    checkvalue = listrecord[x][0]
    if checkvalue[0:4] not in unique_list:
        unique_list.append(checkvalue[0:4])
last_list = []
record =[]
listapp = {}
mese=1
annoapp=0
for z in listrecord:
    anno = listrecord[z][0]
    if (int(annoapp)!=int(anno[0:4])):
        mese = "01"
    annoapp = anno[0:4]
    meseric = anno[4:6]
    if (int(mese)!=int(anno[4:6])):
        mese = int(mese) + 1
    if (int(mese)==int(meseric)):
        print ('%s\t%s' % (listrecord[z][0],listrecord[z][1] ))
    else:
        for me in range(mese,13):
            if (me != int(meseric)):
                me = str(me)
                me= me.rjust(2, '0')
                annomese =str(annoapp) + str(me)
                print ('%s\t%s' % (annomese,0 ))
            else:
                print ('%s\t%s' % (anno,listrecord[z][1] ))
                mese = int(mese) + 1
                break