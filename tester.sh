#!/bin/bash

FILE=gemanim.sh

echo "Test 1: Chybny parametr" >&2
./"$FILE" -p || echo "OK" >&2 
echo "" >&2

soubor=$(mktemp -p . XXXX)
echo "Tester: vytvarim soubor: $soubor"
echo "Test 2: Prazdny konfigurak" >&2
./"$FILE" -f "$soubor" || echo "OK" >&2 
echo "" >&2

echo "Tester: odebiram prava ke cteni: $soubor"
chmod -r "$soubor"
echo "Test 3: Konfigurak bez prav ke cteni" >&2
./"$FILE" -f "$soubor" || echo "OK" >&2 
echo "" >&2

rm "$soubor"
echo "Tester: Mazu soubor: $soubor"
echo "Test 4: Neexistujici konfigurak" >&2
./"$FILE" -f "$soubor" || echo "OK" >&2 
echo "" >&2

soubor=$(mktemp -p . XXXX)
echo "Tester: vytvarim soubor: $soubor"
echo "Test 5: Prazdny konfigurak" >&2
./"$FILE" -- "$soubor" || echo "OK" >&2 
echo "" >&2

chmod -r "$soubor"
echo "Tester: Souboru: $soubor odebiram prava na cteni"
echo "Test 6: Datovy soubor bez prav ke cteni" >&2
./"$FILE" -- "$soubor" || echo "OK" >&2 
echo "" >&2

rm "$soubor"
echo "Tester: Mazu soubor: $soubor"
echo "Test 7: Neexistujici datovy soubor" >&2
./"$FILE" -- "$soubor" || echo "OK" >&2 
echo "" >&2

echo "Test 8: Stazeni dat z webu" >&2
./"$FILE" -T 10 -S 2 -t "[%H:%M:%S]" https://users.fit.cvut.cz/~barinkl/data2 && echo "OK" >&2 
echo "" >&2

echo "Test 9: Neexistujici datovy soubor" >&2
./"$FILE" -T 10 -S 2 -t "[%Y/%m/%d %H:%M:%S]" sinus.data && echo "OK" >&2 
echo "" >&2