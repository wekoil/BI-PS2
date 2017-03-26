#!/bin/bash

#	Nastavi promennou TimeFormat
function setTimeFormat()
{
	declare -p TimeFormat 1>/dev/null 2>/dev/null && echo "Warning: TimeFormat is already set using the last one" >&2
	TimeFormat="$*"
}

#	Nastavi promennou Xmax
function setXmax()
{
	declare -p Xmax 1>/dev/null 2>/dev/null && echo "Warning: Xmax is already set using the last one" >&2
	Xmax="$*"
}

#	Nastavi promennou Xmin
function setXmin()
{
	declare -p Xmin 1>/dev/null 2>/dev/null && echo "Warning: Xmin is already set using the last one" >&2
	[ "$*" == "auto" ] || [ "$*" == "min" ] || [ "$*" ~= "^-?[0-9]+([.][0-9])?$"] && echo neco vypis
	Xmin="$*"
	
}

#	Nastavi promennou Ymax
function setYmax()
{
	declare -p Ymax 1>/dev/null 2>/dev/null && echo "Warning: Ymax is already set using the last one" >&2
	Ymax="$*"
}

#	Nastavi promennou Ymin
#	"^-?[0-9]+([.][0-9])?$"
function setYmin()
{
	declare -p Ymin 1>/dev/null 2>/dev/null && echo "Warning: Ymin is already set using the last one" >&2
	[ "$*" == "auto" || "$*" == "min" || "$*" =~ "^-?[0-9]+([.][0-9])?$" ] && echo neco vypis
	Ymin="$*"
}

#	Nastaveni promennou uvedenou v prvnim parametru na hodnotu uvedenou v dalsich parametrech
function setVariable()
{
	
	a="$1"
	shift
	case "$a" in
			TimeFormat) setTimeFormat "$*";;
			Xmax) setXmax "$*";;
			Xmin) setXmin "$*";;
			Ymax) setYmax "$*";;
			Ymin) setYmin "$*";;
			Speed) Speed="$*";;
			Time) Time="$*";;
			FPS) FPS="$*";;
			CriticalValue) CriticalValue="$*";;
			Legend) Legend="$*";;
			GnuplotParams) GnuplotParams="$*";;
			EffectParams) EffectParams="$*";;
			Name) Name="$*";;
			IgnoreErrors) IgnoreErrors="$*";;
			\?) echo "Pokud se tohle vypsalo, neco je hodne spatne!!!" >&2;;
	esac
}

#	Zpracovani konfiguraku
function loadConfigFile()
{
	[ -f "$1" ] || { echo "Configuration file: $1 does not exist" >&2; exit 2; }
	[ -r "$1" ] || { echo "Configuration file: $1 can not be read because of permitions" >&2; exit 2; }
	[ -s "$1" ] || { echo "Configuration file: $1 is empty" >&2; exit 2; }
	
	OLDIFS="$IFS"
	IFS="
"
	for i in $(cut -d"#" -f1 "$1" | tr "\t" " " | tr -s " " | grep -v "^$" | grep -v "^ $")
	do
		a=$(echo "$i" | cut -d" " -f1)
		b=$(echo "$i" | cut -d" " -f2-)
		setVariable $a $b

	done
	IFS="$OLDIFS"
	[ $DEBUG -eq 1 ] && declare -p

}

#	Zpracovani prepinacu
function loadParam()
{
	[ $DEBUG -eq 1 ] && echo "$*"

	while getopts ":t:y:Y:S:T:e:f:n:x:X:F:c:l:g:E" opt
	do
	  case $opt in
		t) setVariable TimeFormat "${OPTARG}";;
	 	y) setVariable Ymin "${OPTARG}";;
	 	Y) setVariable Ymax "${OPTARG}";;
		S) setVariable Speed "${OPTARG}";;
		T) setVariable Time "${OPTARG}";;
		e) setVariable EffectParams "${OPTARG}";;
		f) loadConfigFile "${OPTARG}"; echo "Configuration file: $OPTARG has been sucesfully loaded";;
		n) setVariable Name "${OPTARG}";;
##### OPTIONAL PARAMS TODO
		X) echo "Warning: Optional param: X has not been implemented" >&2;;
		x) echo "Warning: Optional param: x has not been implemented" >&2;;
		F) echo "Warning: Optional param: F has not been implemented" >&2;;
		c) echo "Warning: Optional param: c has not been implemented" >&2;;
		l) echo "Warning: Optional param: l has not been implemented" >&2;;
		g) echo "Warning: Optional param: g has not been implemented" >&2;;
		E) echo "Warning: Optional param: E has not been implemented" >&2;;
		\?) echo "Unkown param: \"$OPTARG"\" >&2; exit 1;;
	  esac
	done
	[ $DEBUG -eq 1 ] && echo posouvam o/:  `expr ${OPTIND} - 1`
	posuno=`expr ${OPTIND} - 1`
}

#	Zpracovani souboru
function loadFile()
{
	[ $DEBUG -eq 1 ] && echo "$*"
	while [ $# -gt 0 ]
	do
		[ "$1" == "--" ] && shift
 		[ -f "$1" ] || { echo "File: $1 does not exist" >&2; exit 2; }
		[ -r "$1" ] || { echo "File: $1 can not be read because of permitions" >&2; exit 2; }
		[ -s "$1" ] || { echo "File: $1 is empty" >&2; exit 2; }
		cat "$1"
   		shift
	done

}

#	Nastavi vychozi hodnoty nenastavenych promennych
function setDefaultVar()
{
	declare -p TimeFormat 1>/dev/null 2>/dev/null || TimeFormat=
}


# function kontejner()
# {
# 	setVariable($(echo "$i" | cut -d" " -f1), $(echo "$i" | cut -d" " -f2-))
# }