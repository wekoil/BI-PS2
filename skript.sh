#!/bin/bash

##### CONSTANTS #####

DEBUG=0

##### END OF CONSTANTS #####

##### FUNCTIONS #####

#	Zpracovani konfiguraku
function loadConfigFile()
{
	[ -f "$1" ] || { echo "Configuration file: $1 does not exist" ; exit 2; }
	[ -r "$1" ] || { echo "Configuration file: $1 can not be read because of permitions"; exit 2; }
	[ -s "$1" ] || { echo "Configuration file: $1 is empty"; exit 2; }
	
	OLDIFS="$IFS"
	IFS="
"
	for i in $(cut -d"#" -f1 "$1" | tr "\t" " " | tr -s " " | grep -v "^$" | grep -v "^ $")
	do
		case $(echo "$i" | cut -d" " -f1) in
			TimeFormat) TimeFormat=$(echo "$i" | cut -d" " -f2-);;
			Xmax) Xmax=$(echo "$i" | cut -d" " -f2-);;
			Xmin) Xmin=$(echo "$i" | cut -d" " -f2-);;
			Ymax) Ymax=$(echo "$i" | cut -d" " -f2-);;
			Ymin) Ymin=$(echo "$i" | cut -d" " -f2-);;
			Speed) Speed=$(echo "$i" | cut -d" " -f2-);;
			Time) Time=$(echo "$i" | cut -d" " -f2-);;
			FPS) FPS=$(echo "$i" | cut -d" " -f2-);;
			CriticalValue) CriticalValue=$(echo "$i" | cut -d" " -f2-);;
			Legend) Legend=$(echo "$i" | cut -d" " -f2-);;
			GnuplotParams) GnuplotParams=$(echo "$i" | cut -d" " -f2-);;
			EffectParams) EffectParams=$(echo "$i" | cut -d" " -f2-);;
			Name) Name=$(echo "$i" | cut -d" " -f2-);;
			IgnoreErrors) IgnoreErrors=$(echo "$i" | cut -d" " -f2-);;
		esac
	done
	IFS="$OLDIFS"
	[ $DEBUG -eq 1 ] && declare -p
}

#	Zpracovani prepinacu
function loadParam()
{
	[ $DEBUG -eq 1 ] && echo "$*"

	while getopts ":tyYSTef:nxXFclgE" opt
	do
	  case $opt in
		t) echo "nacteno t";;
	 	y) echo "nacteno y";;
	 	Y) echo "nacteno Y";;
		S) echo "nacteno S";;
		T) echo "nacteno T";;
		e) echo "nacteno e";;
		f) loadConfigFile "$OPTARG";;
		n) echo "nacteno n";;
##### OPTIONAL PARAMS TODO
		x) echo "Optional param: x has no been implemented yet";;
		X) echo "Optional param: X has no been implemented yet";;
		F) echo "Optional param: F has no been implemented yet";;
		c) echo "Optional param: c has no been implemented yet";;
		l) echo "Optional param: l has no been implemented yet";;
		g) echo "Optional param: g has no been implemented yet";;
		E) echo "Optional param: E has no been implemented yet";;
		\?) exit 1;;
	  esac
	done
	shift `expr $OPTIND - 1`
}



function kontejner()
{
	echo
}

##### END OF FUNCTIONS #####

##### BEGIN OF SCRIPT #####

loadParam $*

