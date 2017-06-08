#!/bin/bash

FILE=skript.sh
TESTINPUT=testovaciVstup
TESTCONFIG=konfigurag.conf
MOREFILES="treti.data druhy.data prvni.data"
WRONGFILE1="chyba1.data"
WRONGFILE2="chyba2.data"
WRONGFILE3="chyba3.data"

echo "Test 1: Chybny parametr" >&2
./"$FILE" -p >/dev/null || echo "OK" >&2 
echo "" >&2

soubor=$(mktemp -p . XXXX)
echo "Tester: vytvarim soubor: $soubor"
echo "Test 2: Prazdny konfigurak" >&2
./"$FILE" -f "$soubor" >/dev/null || echo "OK" >&2 
echo "" >&2

echo "Tester: odebiram prava ke cteni: $soubor"
chmod -r "$soubor"
echo "Test 3: Konfigurak bez prav ke cteni" >&2
./"$FILE" -f "$soubor" >/dev/null || echo "OK" >&2 
echo "" >&2

rm "$soubor"
echo "Tester: Mazu soubor: $soubor"
echo "Test 4: Neexistujici konfigurak" >&2
./"$FILE" -f "$soubor" >/dev/null || echo "OK" >&2 
echo "" >&2

soubor=$(mktemp -p . XXXX)
echo "Tester: vytvarim soubor: $soubor"
echo "Test 5: Prazdny datovy soubor" >&2
./"$FILE" -- "$soubor" >/dev/null || echo "OK" >&2 
echo "" >&2

chmod -r "$soubor"
echo "Tester: Souboru: $soubor odebiram prava na cteni"
echo "Test 6: Datovy soubor bez prav ke cteni" >&2
./"$FILE" -- "$soubor" >/dev/null || echo "OK" >&2 
echo "" >&2

rm "$soubor"
echo "Tester: Mazu soubor: $soubor"
echo "Test 7: Neexistujici datovy soubor" >&2
./"$FILE" -- "$soubor" >/dev/null || echo "OK" >&2 
echo "" >&2

echo "Test 8: Spusteni bez parametru" >&2
./"$FILE" >/dev/null || echo "OK" >&2 
echo "" >&2

echo "Test 9: Velky test TimeFormatu" >&2
echo "Spatny timeformat" >&2
./"$FILE" -t "[%y/%m/%d %H:%M%S]" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%y/%m/%d %H%M:%S]" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%y/%m/%d%H:%M:%S]" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%y/%m%d %H:%M:%S]" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%y%m/%d %H:%M:%S]" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%m/%d %H:%M:%S]" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%y/%d %H:%M:%S]" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%y/%m %H:%M:%S]" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%y/%m/%d %M:%S]" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%y/%m/%d %H:%S]" >/dev/null || echo "OK" >&2 
./"$FILE" -t "]%y/%m/%d %H:%M:%S[" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%y/%m/%d/%H:%M:%S]" >/dev/null || echo "OK" >&2 
echo "Spravny timeformat" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 10: Test Ymax" >&2
./"$FILE" -Y "maximum" >/dev/null || echo "OK" >&2 
./"$FILE" -Y "10k" >/dev/null || echo "OK" >&2 
./"$FILE" -Y "10" -Y "auto" >/dev/null || echo "OK" >&2 
echo "Ymax jako auto" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -Y "auto" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "Ymax jako max" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -Y "max" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "Ymax jako hodnota 3" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -Y "3" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "" >&2

echo "Test 11: Test Ymin" >&2
./"$FILE" -y "minimum" >/dev/null || echo "OK" >&2 
./"$FILE" -y "-0.10k" >/dev/null || echo "OK" >&2 
./"$FILE" -y "-0.10" -y "min" >/dev/null || echo "OK" >&2 
echo "Ymin jako auto" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -y "auto" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "Ymin jako max" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -y "min" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "Ymin jako hodnota -3" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -y "-3" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "" >&2

echo "Test 12: Test Speed" >&2
./"$FILE" -S "minimum" >/dev/null || echo "OK" >&2 
./"$FILE" -S "10k" >/dev/null || echo "OK" >&2 
./"$FILE" -S "10.5" -S "10" >/dev/null || echo "OK" >&2 
./"$FILE" -F "10" -T "10" -S "10" >/dev/null || echo "OK" >&2 
echo "Speed jako hodnota 3" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -S "3" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "" >&2

echo "Test 13: Test Time" >&2
./"$FILE" -T "minimum" >/dev/null || echo "OK" >&2 
./"$FILE" -T "10k" >/dev/null || echo "OK" >&2 
./"$FILE" -T "10" -T "10" >/dev/null || echo "OK" >&2 
./"$FILE" -F "10" -S "10" -T "10" >/dev/null || echo "OK" >&2 
echo "Time jako hodnota 3" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -T "3" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "" >&2

echo "Test 14: Test FPS" >&2
./"$FILE" -F "minimum" >/dev/null || echo "OK" >&2 
./"$FILE" -F "10k" >/dev/null || echo "OK" >&2 
./"$FILE" -F "10" -F "10" >/dev/null || echo "OK" >&2 
./"$FILE" -S "10" -T "10" -F "10" >/dev/null || echo "OK" >&2 
echo "FPS jako hodnota 3" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -F "3" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "" >&2

echo "Test 15: Test Legendy" >&2
./"$FILE" -l "legenda" -l "nova legenda" >/dev/null || echo "OK" >&2 
echo "Legenda jako hodnota nova legenda" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -l "nova legenda" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "" >&2

echo "Test 16: Test Gnuplot parametru" >&2
./"$FILE" -g "legenda" >/dev/null || echo "OK" >&2 
./"$FILE" -g "nastav mi tlustsi caru" >/dev/null || echo "OK" >&2 
echo "Nastavena hodnota Gnuplot parametru grid" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -g "grid" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "" >&2

echo "Test 17: Test Effekt parametru" >&2
./"$FILE" -e "legenda" >/dev/null || echo "OK" >&2 
./"$FILE" -e "nastav mi tlustsi caru=2mm" >/dev/null || echo "OK" >&2 
./"$FILE" -e "order=00123456789" >/dev/null || echo "OK" >&2 
./"$FILE" -e "order=123456789" >/dev/null || echo "OK" >&2 
./"$FILE" -e "order=0123456788" >/dev/null || echo "OK" >&2 
echo "Nastavena hodnota Effekt parametru order=0123456789" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -e "order=0123456789" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 18: Test Name" >&2
./"$FILE" -n "slozka" -n "nova slozka" >/dev/null || echo "OK" >&2 
echo "Name jako hodnota slozka" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -n "slozka" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 19: Test Spravny konfiguracni soubor" >&2
./"$FILE" -f "$TESTCONFIG" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 20: Test Ignorovani erroru s TimeFormatem" >&2
echo "Spatny a dobry timeformat" >&2
./"$FILE" -E -t "[%Y/%m/%d%H:%M:%S]" -t "[%Y/%m/%d %H:%M:%S]" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "Dobry a spatny timeformat" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -t "[%Y/%m/%d%H:%M:%S]" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 21: Test Ignorovani erroru s Ymax" >&2
echo "Spatny ymax" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -Y "nejaka blbost" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "Dvakrat ymax" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -Y "max" -Y "auto" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "Dobry a spatny ymax" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -Y "max" -Y "nejaka blbost" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 22: Test Ignorovani erroru s Ymin" >&2
echo "Spatny ymin" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -y "nejaka blbost" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "Dvakrat ymin" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -y "min" -y "auto" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "Dobry a spatny ymin" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -y "min" -y "nejaka blbost" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 23: Test Ignorovani erroru se Speed" >&2
echo "Spatny speed" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -S "nejaka blbost" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "Dvakrat speed" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -S "2" -S "3" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "Dobry a spatny speed" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -S "2" -S "nejaka blbost" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "" >&2

echo "Test 24: Test Ignorovani erroru s Time" >&2
echo "Spatny Time" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -T "nejaka blbost" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "Dvakrat Time" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -T "5" -T "2" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "Dobry a spatny Time" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -T "5" -T "nejaka blbost" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "" >&2

echo "Test 25: Test Ignorovani erroru s FPS" >&2
echo "Spatny FPS" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -F "nejaka blbost" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "Dvakrat FPS" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -F "5" -F "2" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "Dobry a spatny FPS" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -F "5" -F "nejaka blbost" "$TESTINPUT" >/dev/null && echo "OK" >&2
echo "" >&2

echo "Test 26: Test Ignorovani erroru s Legendou" >&2
echo "Dvakrat legenda" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -l "legenda" -l "nova legenda" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 27: Test Ignorovani erroru s Name" >&2
echo "Dvakrat name" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -n "slozka" -n "nova slozka" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 28: Test Ignorovani erroru s Time, Speed a FPS" >&2
echo "Nastaven speed time a fps" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -S "2" -T "2" -F "10" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Nastaven fps time a speed" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -F "10" -T "2" -S "2" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Nastaven speed fps a time" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -S "2" -F "10" -T "2" "$TESTINPUT" >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 29: Stazeni dat z webu" >&2
./"$FILE" -o -t "[%H:%M:%S]" https://users.fit.cvut.cz/~barinkl/data2 >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 30: Vsechny prepinace" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -y "min" -Y "max" -S "2" -F "5" -T "20" -l "legenda" -n "zkouska" -g "grid" -e "order=9876543210" sinus.data >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 31: Jiny timeformat - pouze rok" >&2
./"$FILE" -t "%Y" jenrok.data >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 32: Vice vstupnich souboru" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" treti.data druhy.data prvni.data >/dev/null && echo "OK" >&2 
echo "" >&2

echo "Test 33: Soubory ve spatnem formatu" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" "$WRONGFILE1" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" "$WRONGFILE2" >/dev/null || echo "OK" >&2 
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" "$WRONGFILE3" >/dev/null || echo "OK" >&2 
echo "" >&2

echo "Test 34: Jiny timeformat - jine znaky" >&2
./"$FILE" -t "{%Y0%m.%d %H|%Mp%S}" jinyFormat.data >/dev/null && echo "OK" >&2 
echo "" >&2