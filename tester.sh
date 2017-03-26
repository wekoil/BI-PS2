#!/bin/bash

FILE=skript.sh

echo "Test 1: Chybny parametr" >&2
./"$FILE" -p
echo "" >&2

soubor=$(mktemp -p . XXXX)
echo "Tester: vytvarim soubor: $soubor"
echo "Test 2: Prazdny konfigurak" >&2
./"$FILE" -f "$soubor"
echo "" >&2

echo "Tester: odebiram prava ke cteni: $soubor"
chmod -r "$soubor"
echo "Test 3: Konfigurak bez prav ke cteni" >&2
./"$FILE" -f "$soubor"
echo "" >&2

rm "$soubor"
echo "Tester: Mazu soubor: $soubor"
echo "Test 4: Neexistujici konfigurak" >&2
./"$FILE" -f "$soubor"
echo "" >&2

soubor=$(mktemp -p . XXXX)
echo "Tester: vytvarim soubor: $soubor"
echo "Test 5: Prazdny konfigurak" >&2
./"$FILE" -- "$soubor"
echo "" >&2

chmod -r "$soubor"
echo "Tester: Souboru: $soubor odebiram prava na cteni"
echo "Test 6: Datovy soubor bez prav ke cteni" >&2
./"$FILE" -- "$soubor"
echo "" >&2

rm "$soubor"
echo "Tester: Mazu soubor: $soubor"
echo "Test 7: Neexistujici datovy soubor" >&2
./"$FILE" -- "$soubor"
echo "" >&2