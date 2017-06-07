#!/bin/bash

FILE=skript.sh
TESTINPUT=testovaciVstup
TESTCONFIG=konfigurag.conf

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
echo "Test 5: Prazdny datovy soubor" >&2
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

echo "Test 8: Spusteni bez parametru" >&2
./"$FILE" || echo "OK" >&2 
echo "" >&2

echo "Test 9: Velky test TimeFormatu" >&2
echo "Spatny timeformat" >&2
./"$FILE" -t "[%y/%m/%d %H:%M%S]" || echo "OK" >&2 
./"$FILE" -t "[%y/%m/%d %H%M:%S]" || echo "OK" >&2 
./"$FILE" -t "[%y/%m/%d%H:%M:%S]" || echo "OK" >&2 
./"$FILE" -t "[%y/%m%d %H:%M:%S]" || echo "OK" >&2 
./"$FILE" -t "[%y%m/%d %H:%M:%S]" || echo "OK" >&2 
./"$FILE" -t "[%m/%d %H:%M:%S]" || echo "OK" >&2 
./"$FILE" -t "[%y/%d %H:%M:%S]" || echo "OK" >&2 
./"$FILE" -t "[%y/%m %H:%M:%S]" || echo "OK" >&2 
./"$FILE" -t "[%y/%m/%d %M:%S]" || echo "OK" >&2 
./"$FILE" -t "[%y/%m/%d %H:%S]" || echo "OK" >&2 
./"$FILE" -t "]%y/%m/%d %H:%M:%S[" || echo "OK" >&2 
./"$FILE" -t "[%y/%m/%d/%H:%M:%S]" || echo "OK" >&2 
echo "Spravny timeformat" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" "$TESTINPUT" && echo "OK" >&2 
echo "" >&2

echo "Test 10: Test Ymax" >&2
./"$FILE" -Y "maximum" || echo "OK" >&2 
./"$FILE" -Y "10k" || echo "OK" >&2 
./"$FILE" -Y "10" -Y "auto" || echo "OK" >&2 
echo "Ymax jako auto" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -Y "auto" "$TESTINPUT" && echo "OK" >&2 
echo "Ymax jako max" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -Y "max" "$TESTINPUT" && echo "OK" >&2
echo "Ymax jako hodnota 3" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -Y "3" "$TESTINPUT" && echo "OK" >&2
echo "" >&2

echo "Test 11: Test Ymin" >&2
./"$FILE" -y "minimum" || echo "OK" >&2 
./"$FILE" -y "-0.10k" || echo "OK" >&2 
./"$FILE" -y "-0.10" -y "min" || echo "OK" >&2 
echo "Ymin jako auto" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -y "auto" "$TESTINPUT" && echo "OK" >&2 
echo "Ymin jako max" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -y "min" "$TESTINPUT" && echo "OK" >&2
echo "Ymin jako hodnota -3" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -y "-3" "$TESTINPUT" && echo "OK" >&2
echo "" >&2

echo "Test 12: Test Speed" >&2
./"$FILE" -S "minimum" || echo "OK" >&2 
./"$FILE" -S "10k" || echo "OK" >&2 
./"$FILE" -S "10.5" -S "10" || echo "OK" >&2 
./"$FILE" -F "10" -T "10" -S "10" || echo "OK" >&2 
echo "Speed jako hodnota 3" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -S "3" "$TESTINPUT" && echo "OK" >&2
echo "" >&2

echo "Test 13: Test Time" >&2
./"$FILE" -T "minimum" || echo "OK" >&2 
./"$FILE" -T "10k" || echo "OK" >&2 
./"$FILE" -T "10" -T "10" || echo "OK" >&2 
./"$FILE" -F "10" -S "10" -T "10" || echo "OK" >&2 
echo "Time jako hodnota 3" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -T "3" "$TESTINPUT" && echo "OK" >&2
echo "" >&2

echo "Test 14: Test FPS" >&2
./"$FILE" -F "minimum" || echo "OK" >&2 
./"$FILE" -F "10k" || echo "OK" >&2 
./"$FILE" -F "10" -F "10" || echo "OK" >&2 
./"$FILE" -S "10" -T "10" -F "10" || echo "OK" >&2 
echo "FPS jako hodnota 3" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -F "3" "$TESTINPUT" && echo "OK" >&2
echo "" >&2

echo "Test 15: Test Legendy" >&2
./"$FILE" -l "legenda" -l "nova legenda" || echo "OK" >&2 
echo "Legenda jako hodnota nova legenda" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -l "nova legenda" "$TESTINPUT" && echo "OK" >&2
echo "" >&2

echo "Test 16: Test Gnuplot parametru" >&2
./"$FILE" -g "legenda" || echo "OK" >&2 
./"$FILE" -g "nastav mi tlustsi caru" || echo "OK" >&2 
echo "Nastavena hodnota Gnuplot parametru grid" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -g "grid" "$TESTINPUT" && echo "OK" >&2
echo "" >&2

echo "Test 17: Test Effekt parametru" >&2
./"$FILE" -e "legenda" || echo "OK" >&2 
./"$FILE" -e "nastav mi tlustsi caru=2mm" || echo "OK" >&2 
./"$FILE" -e "order=00123456789" || echo "OK" >&2 
./"$FILE" -e "order=123456789" || echo "OK" >&2 
./"$FILE" -e "order=0123456788" || echo "OK" >&2 
echo "Nastavena hodnota Effekt parametru order=0123456789" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -e "order=0123456789" "$TESTINPUT" && echo "OK" >&2 
echo "" >&2

echo "Test 18: Test Name" >&2
./"$FILE" -n "slozka" -n "nova slozka" || echo "OK" >&2 
echo "Name jako hodnota slozka" >&2
./"$FILE" -t "[%Y/%m/%d %H:%M:%S]" -n "slozka" "$TESTINPUT" && echo "OK" >&2 
echo "" >&2

echo "Test 19: Test Spravny konfiguracni soubor" >&2
./"$FILE" -f "$TESTCONFIG" "$TESTINPUT" && echo "OK" >&2 
echo "" >&2

echo "Test 20: Test Ignorovani erroru s TimeFormatem" >&2
echo "Spatny a dobry timeformat" >&2
./"$FILE" -E -t "[%Y/%m/%d%H:%M:%S]" -t "[%Y/%m/%d %H:%M:%S]" "$TESTINPUT" && echo "OK" >&2 
echo "Dobry a spatny timeformat" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -t "[%Y/%m/%d%H:%M:%S]" "$TESTINPUT" && echo "OK" >&2 

echo "Test 21: Test Ignorovani erroru s Ymax" >&2
echo "Spatny ymax" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -Y "nejaka blbost" "$TESTINPUT" && echo "OK" >&2
echo "Dvakrat ymax" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -Y "max" -Y "auto" "$TESTINPUT" && echo "OK" >&2 
echo "Dobry a spatny ymax" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -Y "max" -Y "nejaka blbost" "$TESTINPUT" && echo "OK" >&2 

echo "Test 22: Test Ignorovani erroru s Ymin" >&2
echo "Spatny ymin" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -y "nejaka blbost" "$TESTINPUT" && echo "OK" >&2
echo "Dvakrat ymin" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -y "min" -y "auto" "$TESTINPUT" && echo "OK" >&2 
echo "Dobry a spatny ymin" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -y "min" -y "nejaka blbost" "$TESTINPUT" && echo "OK" >&2 

echo "Test 23: Test Ignorovani erroru se Speed" >&2
echo "Spatny speed" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -S "nejaka blbost" "$TESTINPUT" && echo "OK" >&2
echo "Dvakrat speed" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -S "2" -S "3" "$TESTINPUT" && echo "OK" >&2
echo "Dobry a spatny speed" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -S "2" -S "nejaka blbost" "$TESTINPUT" && echo "OK" >&2

echo "Test 24: Test Ignorovani erroru s Time" >&2
echo "Spatny Time" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -T "nejaka blbost" "$TESTINPUT" && echo "OK" >&2
echo "Dvakrat Time" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -T "5" -T "2" "$TESTINPUT" && echo "OK" >&2
echo "Dobry a spatny Time" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -T "5" -T "nejaka blbost" "$TESTINPUT" && echo "OK" >&2

echo "Test 25: Test Ignorovani erroru s FPS" >&2
echo "Spatny FPS" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -F "nejaka blbost" "$TESTINPUT" && echo "OK" >&2
echo "Dvakrat FPS" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -F "5" -F "2" "$TESTINPUT" && echo "OK" >&2
echo "Dobry a spatny FPS" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -F "5" -F "nejaka blbost" "$TESTINPUT" && echo "OK" >&2

echo "Test 26: Test Ignorovani erroru s Legendou" >&2
echo "Dvakrat legenda" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -l "legenda" -l "nova legenda" "$TESTINPUT" && echo "OK" >&2 

echo "Test 27: Test Ignorovani erroru s Name" >&2
echo "Dvakrat name" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -n "slozka" -n "nova slozka" "$TESTINPUT" && echo "OK" >&2 
echo "" >&2

echo "Test 28: Test Ignorovani erroru s Time, Speed a FPS" >&2
echo "Nastaven speed time a fps" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -S "10" -T "10" -F "10" "$TESTINPUT" && echo "OK" >&2 
echo "" >&2

echo "Nastaven fps time a speed" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -F "10" -T "10" -S "10" "$TESTINPUT" && echo "OK" >&2 
echo "" >&2

echo "Nastaven speed fps a time" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -S "10" -F "10" -T "10" "$TESTINPUT" && echo "OK" >&2 
echo "" >&2

echo "Test 29: Stazeni dat z webu" >&2
./"$FILE" -o -t "[%H:%M:%S]" https://users.fit.cvut.cz/~barinkl/data2 && echo "OK" >&2 
echo "" >&2

echo "Test 30: Vsechny prepinace" >&2
./"$FILE" -E -t "[%Y/%m/%d %H:%M:%S]" -y "min" -Y "max" -S "2" -F "5" -T "20" -l "legenda" -n "zkouska" -g "grid" -e "order=9876543210" sinus.data && echo "OK" >&2 
echo "" >&2

echo "Test 31: Jiny timeformat - pouze rok" >&2
./"$FILE" -t "%Y" jenrok.data && echo "OK" >&2 
echo "" >&2