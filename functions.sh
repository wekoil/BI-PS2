#!/bin/bash

#	Nastaveni promennou uvedenou v prvnim parametru na hodnotu uvedenou v dalsich parametrech
function setVariable()
{
	
	a="$1"
	shift
	declare -p $a
	declare -g "$a"="$*"
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

		# case $(echo "$i" | cut -d" " -f1) in
		# 	TimeFormat) TimeFormat=$(echo "$i" | cut -d" " -f2-);;
		# 	Xmax) Xmax=$(echo "$i" | cut -d" " -f2-);;
		# 	Xmin) Xmin=$(echo "$i" | cut -d" " -f2-);;
		# 	Ymax) Ymax=$(echo "$i" | cut -d" " -f2-);;
		# 	Ymin) Ymin=$(echo "$i" | cut -d" " -f2-);;
		# 	Speed) Speed=$(echo "$i" | cut -d" " -f2-);;
		# 	Time) Time=$(echo "$i" | cut -d" " -f2-);;
		# 	FPS) FPS=$(echo "$i" | cut -d" " -f2-);;
		# 	CriticalValue) CriticalValue=$(echo "$i" | cut -d" " -f2-);;
		# 	Legend) Legend=$(echo "$i" | cut -d" " -f2-);;
		# 	GnuplotParams) GnuplotParams=$(echo "$i" | cut -d" " -f2-);;
		# 	EffectParams) EffectParams=$(echo "$i" | cut -d" " -f2-);;
		# 	Name) Name=$(echo "$i" | cut -d" " -f2-);;
		# 	IgnoreErrors) IgnoreErrors=$(echo "$i" | cut -d" " -f2-);;
		# esac
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
		t) echo "nacteno t a ${OPTARG}";;
	 	y) echo "nacteno y a ${OPTARG}";;
	 	Y) echo "nacteno Y a ${OPTARG}";;
		S) echo "nacteno S a ${OPTARG}";;
		T) echo "nacteno T a ${OPTARG}";;
		e) echo "nacteno e a ${OPTARG}";;
		f) loadConfigFile "${OPTARG}"; echo "Configuration file: $OPTARG has been sucesfully loaded";;
		n) setVariable Name "${OPTARG}";;
##### OPTIONAL PARAMS TODO
		x) echo "Warning: Optional param: x has no been implemented" >&2;;
		X) echo "Warning: Optional param: X has no been implemented" >&2;;
		F) echo "Warning: Optional param: F has no been implemented" >&2;;
		c) echo "Warning: Optional param: c has no been implemented" >&2;;
		l) echo "Warning: Optional param: l has no been implemented" >&2;;
		g) echo "Warning: Optional param: g has no been implemented" >&2;;
		E) echo "Warning: Optional param: E has no been implemented" >&2;;
		\?) echo "Unkown param: \"$OPTARG"\" >&2; exit 1;;
	  esac
	done
	[ $DEBUG -eq 1 ] && echo posouvam o/:  `expr ${OPTIND} - 1`
	return `expr ${OPTIND} - 1`
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


# function kontejner()
# {
# 	setVariable($(echo "$i" | cut -d" " -f1), $(echo "$i" | cut -d" " -f2-))
# }