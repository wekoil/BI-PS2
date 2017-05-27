#!/bin/bash

##### Constants #####
DEBUG=0
OUTPUT=output

# kvuli sortu, ktery bez tohoto funguje podivne
export LC_ALL=C
#####		#####


##### Functions #####

#	Vypise error a skonci
function err()
{
	echo "ERROR: $*" >&2
	exit 1;
}


#	Vypise warning a pokracuje, kde skoncil
function warr()
{
	echo "WARNING: $*" >&2
}


#	Funkce zkontroluje zda he spravne zadany timeformat a pripadne vyhodi error
function testTimeFormat()
{
	echo "$TimeFormat" | tr -dc "%YymdHMS" | grep "^%[yY]%m%d%H%M%S$" >/dev/null 2>/dev/null || echo "$TimeFormat" | tr -dc "%YymdHMS" | grep "^%[yY]%m%d%H%M$" >/dev/null 2>/dev/null || echo "$TimeFormat" | tr -dc "%YymdHMS" | grep "^%[yY]%m%d%H$" >/dev/null 2>/dev/null || echo "$TimeFormat" | tr -dc "%YymdHMS" | grep "^%[yY]%m%d$" >/dev/null 2>/dev/null || echo "$TimeFormat" | tr -dc "%YymdHMS" | grep "^%[yY]%m$" >/dev/null 2>/dev/null || echo "$TimeFormat" | tr -dc "%YymdHMS" | grep "^%[yY]$" >/dev/null 2>/dev/null || err "Wrong TimeFormat"
	echo "$TimeFormat" | cut -d"%" -f8- | grep "." >/dev/null 2>/dev/null && err "Wrong TimeFormat"
}

#	Nastavi promennou TimeFormat
#	-t
function setTimeFormat()
{

	declare -p TimeFormat 1>/dev/null 2>/dev/null && err "TimeFormat is already set"
	TimeFormat="$*"
	# testTimeFormat
}


#	Fce otestuje promenou Xmax nebo Xmin dle zadaneho timeformatu
function testXLabel()
{
	declare -p TimeFormat 1>/dev/null 2>/dev/null || err "Cannot declare Xmax or Xmin before TimeFormat!"
	date "+$TimeFormat" -d "$*" >/dev/null 2>/dev/null || err "Wrong format on Xmax or Xmin"
}

#	Nastavi promennou Xmax
#	-X
function setXmax()
{
	declare -p Xmax 1>/dev/null 2>/dev/null && err "Xmax is already set"
	[[ "$*" == "auto" || "$*" == "max" ]] || testXLabel "$*"
	Xmax="$*"
}


#	Nastavi promennou Xmin
#	-x
function setXmin()
{
	declare -p Xmin 1>/dev/null 2>/dev/null && err "Xmin is already set"
	[[ "$*" == "auto" || "$*" == "min" ]] || testXLabel "$*"
	Xmin="$*"
	
}


#	Nastavi promennou Ymax
#	-Y
function setYmax()
{
	declare -p Ymax 1>/dev/null 2>/dev/null && err "Ymax is already set"
	[[ "$*" == "auto" || "$*" == "max" || "$*" =~ ^-?[0-9]+([.][0-9]+)?$ ]] || err "Invalid param for Ymax. Supported params are: \"auto\", \"max\" or value"
	Ymax="$*"
}


#	Nastavi promennou Ymin
#	-y
function setYmin()
{
	declare -p Ymin 1>/dev/null 2>/dev/null && err "Ymin is already set"
	[[ "$*" == "auto" || "$*" == "min" || "$*" =~ ^-?[0-9]+([.][0-9]+)?$ ]] || err "Invalid param for Ymin. Supported params are: \"auto\", \"min\" or value"
	Ymin="$*"
}


#	Nastavi promennou Speed
#	-S
function setSpeed()
{
	
	declare -p Time 1>/dev/null 2>/dev/null && declare -p FPS 1>/dev/null 2>/dev/null && err "Cannot use param Speed while params FPS and Time are already set"
	declare -p speed 1>/dev/null 2>/dev/null && err "Speed is already set"
	[[ "$*" =~ ^[0-9]+([.][0-9]+)?$ ]] || err "Invalid param for Speed. Supported is only a value"
	speed="$*"
	[ "$DEBUG" -eq "1" ] && echo "Speed: $speed"
}


#	Nastavi promennou Time
#	-T
function setTime()
{
	declare -p speed 1>/dev/null 2>/dev/null && declare -p FPS 1>/dev/null 2>/dev/null && err "Cannot use param Time while params FPS and Speed are already set"
	declare -p Time 1>/dev/null 2>/dev/null && err "Time is already set"
	[[ "$*" =~ ^[0-9]+([.][0-9]+)?$ ]] || err "Invalid param for Time. Supported is only a value"
	Time="$*"
}

#	Nastavi promennou FPS
#	-F
function setFPS()
{
	declare -p FPS 1>/dev/null 2>/dev/null && err "FPS is already set"
	declare -p speed 1>/dev/null 2>/dev/null && declare -p Time 1>/dev/null 2>/dev/null && err "Cannot use param FPS while params Time and Speed are already set"
	[[ "$*" =~ ^[0-9]+$ ]] || err "Invalid param for FPS. Supported is only an integer"
	FPS="$*"
}

#	Funkce otestuje poradi sloupcu
function testOrder()
{
	[ "$(echo "$*" cut -d"=" -f1)" == "order" ] && order=$(echo "$*" cut -d"=" -f2)
	[ "$(echo "$order" | wc -c)" ]
}

#	Nastavi promennou EffectParams
#	Moznosti: order="poradisloupcu":randomorder=
#	-e
function setEffectParams()
{
	declare -p EffectParams 1>/dev/null 2>/dev/null && EffectParams="$EffectParams:$*"
	declare -p EffectParams 1>/dev/null 2>/dev/null || EffectParams="$*"
	[ "$DEBUG" -eq "1" ] && echo "Efekty: $EffectParams" | tr ":" "\n"
}


#	Nastavi promennou Name
#	-n
function setName()
{
	declare -p Name 1>/dev/null 2>/dev/null && err "Name is already set"
	Name="$*"
}


#	Nastaveni promennou uvedenou v prvnim parametru na hodnotu uvedenou v dalsich parametrech
function setVariable()
{
	
	a="$1"
	shift
	case "$a" in
			timeformat) setTimeFormat "$*";;
			xmax) Xmax="$*";;
			xmin) Xmin="$*";;
			ymax) setYmax "$*";;
			ymin) setYmin "$*";;
			speed) setSpeed "$*";;
			time) setTime "$*";;
			fps) FPS="$*";;
			criticalvalue) CriticalValue="$*";;
			legend) Legend="$*";;
			gnuplotparams) GnuplotParams="$*";;
			effectparams) setEffectParams "$*";;
			name) setName "$*";;
			ignoreerrors) IgnoreErrors="$*";;
			\?) warr "Pokud se tohle vypsalo, asi mas blbe konfigurak";;
	esac
}


#	Zpracovani konfiguraku
function loadConfigFile()
{
	[ -f "$1" ] || err "Configuration file: $1 does not exist"
	[ -r "$1" ] || err "Configuration file: $1 can not be read because of permitions"
	[ -s "$1" ] || err "Configuration file: $1 is empty"
	
	OLDIFS="$IFS"
	IFS="
"
	for i in $(cut -d"#" -f1 "$1" | tr "\t" " " | tr -s " " | grep -v "^$" | grep -v "^ $")
	do
		a=$(echo "$i" | cut -d" " -f1)
		b=$(echo "$i" | cut -d" " -f2-)
		[ "$DEBUG" -eq "1" ] && echo "nacitam z konfigu: ${a,,} $b"
		setVariable ${a,,} $b

	done
	IFS="$OLDIFS"
	[ "$DEBUG" -eq "1" ] && declare -p

}


#	Zpracovani prepinacu
function loadParam()
{
	[ $DEBUG -eq 1 ] && echo "Parametry: \"$*\""

	while getopts ":t:y:Y:S:T:e:f:n:x:X:F:c:l:g:Ed" opt
	do
	  case $opt in
		t) setTimeFormat "${OPTARG}";;
		d) DEBUG=1;;
	 	y) setYmin "${OPTARG}";;
	 	Y) setYmax "${OPTARG}";;
		S) setSpeed "${OPTARG}";;
		T) setTime "${OPTARG}";;
		e) setEffectParams "${OPTARG}";;
		f) loadConfigFile "${OPTARG}"; [ "$DEBUG" -eq "1" ] && echo "Configuration file: $OPTARG has been sucesfully loaded";;
		n) setName "${OPTARG}";;
##### OPTIONAL PARAMS TODO
		X) setXmax "${OPTARG}";;
		x) setXmin "${OPTARG}";;
		F) setFPS "${OPTARG}";;
		c) warr "Optional param: c has not been implemented";;
		l) warr "Optional param: l has not been implemented";;
		g) warr "Optional param: g has not been implemented";;
		E) warr "Optional param: E has not been implemented";;
		\?) err "Unkown param: \"$OPTARG\"";;
	  esac
	done
	[ $DEBUG -eq 1 ] && echo posouvam o\:  `expr ${OPTIND} - 1`
	shifto=$(expr ${OPTIND} - 1)
}

#	funkce stahne soubot z webu
function downloadFile
{

	wget -O "$TMP/DATA" "$1" >/dev/null 2>/dev/null || err "Cannot dowload file from URL: $1"
}

#	Zpracovani souboru
function loadFile()
{
	TMP=$(mktemp -d) || err "Cannot create temporary directory"
	[ "$DEBUG" -eq "1" ] && echo "Jmeno tmp adresare: $TMP"


	[ $# -eq 1 ] || err "Please type file name"
	[ "$DEBUG" -eq "1" ] && echo "nacitam soubory: $*"
	while [ $# -gt 0 ]
	do
		[ "$1" == "--" ] && shift
		if [[ "$1" =~ ^https?:// ]]
		then 
			downloadFile "$1"
			[ -f "$TMP/DATA" ] || err "File: $TMP/DATA does not exist"
			[ -r "$TMP/DATA" ] || err "File: $TMP/DATA can not be read because of permitions"
			[ -s "$TMP/DATA" ] || err "File: $TMP/DATA is empty"
			declare -p DATA 1>/dev/null 2>/dev/null && DATA+=$(echo ;cat "$TMP/DATA")
			declare -p DATA 1>/dev/null 2>/dev/null || DATA=$(cat "$TMP/DATA")
		else
	 		[ -f "$1" ] || err "File: $1 does not exist"
			[ -r "$1" ] || err "File: $1 can not be read because of permitions"
			[ -s "$1" ] || err "File: $1 is empty"
			declare -p DATA 1>/dev/null 2>/dev/null && DATA+=$(echo ;cat "$1")
			declare -p DATA 1>/dev/null 2>/dev/null || DATA=$(cat "$1")
   		fi
   		shift
	done


	generategraph
	# echo "$DATA"
}

function testFormat()
{
	for ((i=1;i<LINES;i++))
	do
		dataFromFile=$(head -"$i" sinus.data | tail -1 | awk '{$NF=""; print $0}' | tr -d "[]")
		[ "$DEBUG" -eq "1" ] && echo "$dataFromFile"
		[ "$DEBUG" -eq "1" ] && echo "$(date "+$TimeFormat" -d "$(echo "$dataFromFile" | tr -d -c "0123456789 /-:")")"
		[ "$(date "+$TimeFormat" -d "$(echo "$dataFromFile" | tr -d -c "0123456789 /-:")") " == "$dataFromFile" ] || err "Wrong format on line $i"
	done
}

#	Funkce nastavi tyto 3 promenne
function setdefaultFpsTimeSpeed()
{
	if [[ "$speed" =~ ^[0-9]+([.][0-9]+)?$ ]]
	then
		if [[ "$Time" =~ ^[0-9]+([.][0-9]+)?$ ]];
		then
			FPS=$(echo "$LINES/$Time/$speed" | bc);
		else
			if [[ "$FPS" =~ ^[0-9]+$ ]]
			then
				Time=$( echo "$LINES/($FPS*$speed)" | bc )
			else
				FPS="25"
			fi
		fi
	else
		if [[ "$Time" =~ ^[0-9]+([.][0-9]+)?$ ]]
		then
			if [[ "$FPS" =~ ^[0-9]+$ ]]
			then
				speed=$( echo "$LINES/($FPS*$Time)" | bc )
			else
				speed="1"
				FPS=$( echo "$LINES/($Time*$speed)" | bc )
			fi
		else
			if [[ "$FPS" =~ ^[0-9]+$ ]]
			then
				speed="1"
			else
				speed="1"
				FPS="25"
			fi
		fi
	fi
	[ "$DEBUG" -eq "1" ] && echo "Speed: $speed, FPS: $FPS, time: $Time"
}

#	Nastavi vychozi hodnoty nenastavenych promennych (jen pokud je uzivatel nezadal)
function setDefaultVar()
{
	
	declare -p TimeFormat 1>/dev/null 2>/dev/null || TimeFormat="%Y-%m-%d %H:%M:%S"
	declare -p Ymax 1>/dev/null 2>/dev/null || Ymax="auto"
	declare -p Ymin 1>/dev/null 2>/dev/null || Ymin="auto"
	declare -p Name 1>/dev/null 2>/dev/null || Name=$(cut -d"/" -f2- <<< "$0")
}


#	Uklizeci funkce, ktera po sobe vse uklidi, je zavolana na konci skriptu
function finish()
{
	[ "$DEBUG" -eq "1" ] && echo "uklizim" 2>/dev/null
	rm -rf "$TMP" 2>/dev/null
}
trap finish EXIT

#	Fce zkopirovana ze StackOverflow
#	This function shuffles the elements of an array in-place using the Knuth-Fisher-Yates shuffle algorithm.
function shuffle() 
{
   local i tmp size max rand

   # $RANDOM % (i+1) is biased because of the limited range of $RANDOM
   # Compensate by using a range which is a multiple of the array size.
   size=${#array[*]}
   max=$(( 32768 / size * size ))

   for ((i=size-1; i>0; i--)); do
      while (( (rand=$RANDOM) >= max )); do :; done
      rand=$(( rand % (i+1) ))
      tmp=${array[i]} array[i]=${array[rand]} array[rand]=$tmp
   done
}

function generategraph()
{
	
	XRANGE=$(awk '{$NF=""; print $0}' <<< "$DATA" | sed -n '1p;$p' | paste -d: -s)

	LINES=$(wc -l <<< "$DATA")

	testFormat
	
	numberOfRecords=$( echo "$LINES/10" | bc)
	array[0]=$( head -"$numberOfRecords" <<< "$DATA")
	array[1]=$( head -$( echo "$numberOfRecords*2" | bc ) <<< "$DATA" | tail -"$numberOfRecords")
	array[2]=$( head -$( echo "$numberOfRecords*3" | bc ) <<< "$DATA" | tail -"$numberOfRecords")
	array[3]=$( head -$( echo "$numberOfRecords*4" | bc ) <<< "$DATA" | tail -"$numberOfRecords")
	array[4]=$( head -$( echo "$numberOfRecords*5" | bc ) <<< "$DATA" | tail -"$numberOfRecords")
	array[5]=$( head -$( echo "$numberOfRecords*6" | bc ) <<< "$DATA" | tail -"$numberOfRecords")
	array[6]=$( head -$( echo "$numberOfRecords*7" | bc ) <<< "$DATA" | tail -"$numberOfRecords")
	array[7]=$( head -$( echo "$numberOfRecords*8" | bc ) <<< "$DATA" | tail -"$numberOfRecords")
	array[8]=$( head -$( echo "$numberOfRecords*9" | bc ) <<< "$DATA" | tail -"$numberOfRecords")
	array[9]=$( tail -$( echo "$LINES-($numberOfRecords*9)" | bc ) <<< "$DATA") 


	shuffle
	
	necoCoNicNeprepise=$(printf "%s\n" "${array[@]}")

	YRANGE=$(echo "$DATA" | awk '{print $NF}' | sort -n | sed -n '1p;$p' | paste -d: -s)
	[ "$DEBUG" -eq "1" ] && echo "Yrange: $YRANGE"
	[ "$Ymin" == "min" ] && Ymin=$(cut -d":" -f1 <<< $YRANGE)
	[ "$Ymax" == "max" ] && Ymax=$(cut -d":" -f2 <<< $YRANGE)
	[ "$Ymin" == "auto" ] && Ymin="*"
	[ "$Ymax" == "auto" ] && Ymax="*"
	FMT=$TMP/%0${#LINES}d.png
	
	
	setdefaultFpsTimeSpeed
	# Vygenerovat snimky animace
	# set -x
	# set -v
	i="$speed"
	counter=1
	sloupce=$( echo "$(tail -1 <<< "$necoCoNicNeprepise" | tr -dc " " | wc -c)+1" | bc)
	[ "$DEBUG" -eq "1" ] && echo "sloupce: $sloupce"
	while [ $(echo "$i" | cut -d"." -f1) -lt "$LINES" ]
	do
		GP=$( cat <<-GNUPLOT
		set terminal png
		set output "$(printf "$FMT" "$counter")"
		set timefmt "$TimeFormat"
		set xdata time
		set yrange [$Ymin:$Ymax]
		plot '-' using 1:$sloupce with lines t ''
		GNUPLOT
		)

		DATA=$(printf "%s\n" "$necoCoNicNeprepise" | head -"$(echo "$i" | cut -d"." -f1)" | sort)

		printf "%s\n" "$GP" "$DATA" | gnuplot 2>/dev/null
		
		i=$(echo "$i+$speed" | bc)
		counter=$( echo "$counter+1" | bc)
	done
	# set +x
	# set +v
	[ "$DEBUG" -eq "1" ] && echo "Snimky jsou done, delam video z adresare: $FMT"
	[ "$DEBUG" -eq "1" ] && echo "video: $Name/anim.mp4"
	ffmpeg -r "$FPS" -i "$FMT" -- "$Name/anim.mp4" >/dev/null 2>/dev/null
	
}

function max_item () 
{ 
	maximalniCislo=$(ls -a | egrep "^$1_[0-9]+$" | awk -F'_' '{print $NF}' | sort -n | tail -1)
	[ "$DEBUG" -eq "1" ] && echo "maximalniCislo: $maximalniCislo"
}


function createDirectory()
{
	max_item $Name
	if [ $(wc -l <<< "$maximalniCislo") -eq 0 ]
	then
		Name+="_1"
	else
		maximalniCislo=$(($maximalniCislo+1))
		Name+="_$maximalniCislo"
	fi

	[ "$DEBUG" -eq "1" ] && echo "Jmeno adresare: $Name"
	mkdir "$Name" 2>/dev/null || err "Cannot create dir: $Name"
}


#	Uschovna veci, co se mozna budou jeste hodit

# 	setVariable($(echo "$i" | cut -d" " -f1), $(echo "$i" | cut -d" " -f2-))
#	"^-?[0-9]+([.][0-9])?$"

##########

##### Pomyslny main #####

loadParam "$@"
shift "$shifto"
setDefaultVar
mkdir "$Name" 2>/dev/null || createDirectory
loadFile "$@"
exit 0

# Nekonecny cyklus na testovani
# while true
# do
# 	sleep 2
# done