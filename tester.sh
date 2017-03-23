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

# echo "Test 5: Neocekavane ukonceni" >&2
# ./"$FILE" -f konfigurag.conf&
# kill $(pgrep "$FILE")
# echo "" >&2

