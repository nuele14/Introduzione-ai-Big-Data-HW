#!/usr/bin/env python
# Marco La Ventura
# Matricola: 627HHHINGINFOR # reduce per calacolo varianza
import sys
import numpy
import statistics
current_word = None
lista_value = []
value = 0
word = None
for line in sys.stdin:
    line = line.strip()
    word, value = line.split('\t', 1)
    try:
        value = float(value)
    except ValueError:
        continue
    if current_word == word:
        if (value!=0):
            lista_value.append(value)
        else:
            lista_value.append(0)
    else:
        if current_word:
            is_all_zero = not numpy.any(lista_value)
            if is_all_zero:
                print ('%s %s' % (current_word, 0))
            else:
                print ('%s %s' % (current_word, round(statistics.variance(lista_value),2)))
            lista_value = []
        if (value!=0):
            lista_value.append(value)
        else:
            lista_value.append(0)
        current_word = word
    if current_word == word:
        if lista_value:
            print('%s %s' % (current_word, round(statistics.variance(lista_value),2)))