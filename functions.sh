#!/bin/bash

# Funkce pro skript (generovani animace z dat)


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


#	Nastavi promennou TimeFormat
#	-t
function setTimeFormat()
{
	declare -p TimeFormat 1>/dev/null 2>/dev/null && warr "TimeFormat is already set using the last one"
	TimeFormat="$*"
}


#	Nastavi promennou Xmax
#	-X
function setXmax()
{
	declare -p Xmax 1>/dev/null 2>/dev/null && warr "Xmax is already set using the last one"
	[[ "$*" == "auto" || "$*" == "max" || "$*" =~ ^-?[0-9]+([.][0-9]+)?$ ]] || err "Invalid param for Xmax. Supported params are: \"auto\", \"max\" or value"
	Xmax="$*"
}


#	Nastavi promennou Xmin
#	-x
function setXmin()
{
	declare -p Xmin 1>/dev/null 2>/dev/null && warr "Xmin is already set using the last one"
	[[ "$*" == "auto" || "$*" == "min" || "$*" =~ ^-?[0-9]+([.][0-9]+)?$ ]] || err "Invalid param for Xmin. Supported params are: \"auto\", \"min\" or value"
	Xmin="$*"
	
}


#	Nastavi promennou Ymax
#	-Y
function setYmax()
{
	declare -p Ymax 1>/dev/null 2>/dev/null && warr "Ymax is already set using the last one"
	[[ "$*" == "auto" || "$*" == "max" || "$*" =~ ^-?[0-9]+([.][0-9]+)?$ ]] || err "Invalid param for Ymax. Supported params are: \"auto\", \"max\" or value"
	Ymax="$*"
}


#	Nastavi promennou Ymin
#	-y
function setYmin()
{
	declare -p Ymin 1>/dev/null 2>/dev/null && warr "Ymin is already set using the last one"
	[[ "$*" == "auto" || "$*" == "min" || "$*" =~ ^-?[0-9]+([.][0-9]+)?$ ]] || err "Invalid param for Ymin. Supported params are: \"auto\", \"min\" or value"
	Ymin="$*"
}


#	Nastavi promennou Speed
function setSpeed()
{
	echo "$*"
	declare -p Time 1>/dev/null 2>/dev/null && warr "Param for Time is now unset. Using Speed instead" && unset Time
	declare -p Speed 1>/dev/null 2>/dev/null && warr "Speed is already set using the last one"
	[[ "$*" =~ ^[0-9]+([.][0-9]+)?$ ]] || err "Invalid param for Speed. Supported is only a value"
	Speed="$*"
}


#	Nastavi promennou Time
#	-T
function setTime()
{
	declare -p Speed 1>/dev/null 2>/dev/null && warr "Param for Speed is now unset. Using Time instead" && unset Speed
	declare -p Time 1>/dev/null 2>/dev/null && warr "Time is already set using the last one"
	[[ "$*" =~ ^[0-9]+([.][0-9]+)?$ ]] || err "Invalid param for Time. Supported is only a value"
	Time="$*"
}


#	Nastavi promennou EffectParams
#	-e
function setEffectParams()
{
	#	TOHLE JESTE MUSIS DODELAT!!!!!!!
	EffectParams="$*"
	echo "$EffectParams" | tr ":" "\n"
}


#	Nastavi promennou Time
#	-T
function setName()
{
	declare -p Name 1>/dev/null 2>/dev/null && warr "Name is already set using the last one"
	Name="$*"
}


#	Nastaveni promennou uvedenou v prvnim parametru na hodnotu uvedenou v dalsich parametrech
function setVariable()
{
	
	a="$1"
	shift
	case "$a" in
			timeFormat) setTimeFormat "$*";;
			xmax) Xmax="$*";;
			xmin) Xmin="$*";;
			ymax) setYmax "$*";;
			ymin) setYmin "$*";;
			speed) setSpeed "$*";;
			time) setTime "$*";;
			fps) FPS="$*";;
			criticalValue) CriticalValue="$*";;
			legend) Legend="$*";;
			gnuplotParams) GnuplotParams="$*";;
			effectParams) setEffectParams "$*";;
			name) setName "$*";;
			ignoreErrors) IgnoreErrors="$*";;
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
		echo "${a,,} $b"
		setVariable ${a,,} $b

	done
	IFS="$OLDIFS"
	[ "$DEBUG" -eq "1" ] && declare -p

}


#	Zpracovani prepinacu
function loadParam()
{
	[ $DEBUG -eq 1 ] && echo "$*"

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
		X) warr "Optional param: X has not been implemented";;
		x) warr "Optional param: x has not been implemented";;
		F) warr "Optional param: F has not been implemented";;
		c) warr "Optional param: c has not been implemented";;
		l) warr "Optional param: l has not been implemented";;
		g) warr "Optional param: g has not been implemented";;
		E) warr "Optional param: E has not been implemented";;
		\?) err "Unkown param: \"$OPTARG\"";;
	  esac
	done
	[ $DEBUG -eq 1 ] && echo posouvam o/:  `expr ${OPTIND} - 1`
	posuno=`expr ${OPTIND} - 1`
}


#	Zpracovani souboru
function loadFile()
{
	[ "$DEBUG" -eq "1" ] && echo "$*"
	while [ $# -gt 0 ]
	do
		[ "$1" == "--" ] && shift
 		[ -f "$1" ] || err "File: $1 does not exist"
		[ -r "$1" ] || err "File: $1 can not be read because of permitions"
		[ -s "$1" ] || err "File: $1 is empty"
		cat "$1"
   		shift
	done

}


#	Nastavi vychozi hodnoty nenastavenych promennych (jen pokud je uzivatel nezadal)
function setDefaultVar()
{
	declare -p TimeFormat 1>/dev/null 2>/dev/null || TimeFormat="[%Y-%m-%d %H:%M:%S]"
	declare -p Ymax 1>/dev/null 2>/dev/null || Ymax="auto"
	declare -p Ymin 1>/dev/null 2>/dev/null || Ymin="auto"
	declare -p Speed 1>/dev/null 2>/dev/null || Speed="1"
}


#	Uklizeci funkce, ktera po sobe vse uklidi, je zavolana na konci skriptu
function finish()
{
	[ "$DEBUG" -eq "1" ] && echo uklizim
}
trap finish EXIT






#	Uschovna veci, co se mozna budou jeste hodit

# 	setVariable($(echo "$i" | cut -d" " -f1), $(echo "$i" | cut -d" " -f2-))
#	"^-?[0-9]+([.][0-9])?$"