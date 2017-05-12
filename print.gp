# nastaveni typu vystupu (terminal = png), volitelne font a velikost
set terminal png
 
# vystupni soubor
set output "sin_day_real.png"
 
# format casu v souboru
set timefmt "[%Y/%m/%d %H:%M:%S]"
 
# na ose x bude cas (jinak cisla), format popisku na ose x
set xdata time
set format x "%H:%M"
 
# popis os
set xlabel "Cas"
set ylabel "Hodnota"
set y2label "Hodnota"
 
# titulek grafu
set title "sin in real"
 
# zobrazeni mrizky grafu
set grid
 
# samotne vykresleni dat ze souboru 'sin_day_real.data',\
# na ose x bude 1. sloupec, na ose y bude 3. sloupec (! mezera v casove znacce),
# graf bude vykreslen carou (s legendou "sin_day_real")
plot './sinus.data' using 1:3 with line title "sin_day_real"