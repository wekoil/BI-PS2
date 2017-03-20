#!/bin/bash

	while getopts "tyYSTefn" opt
	do
	  case $opt in
		t)
		  echo "nacteno t"
		  ;;
	 	y)
		  echo "nacteno y"
		  ;;
	 	Y)
		  echo "nacteno Y"
		  ;;
		S)
		  echo "nacteno S"
		  ;;
		T)
		  echo "nacteno T"
		  ;;
		e)
		  echo "nacteno e"
		  ;;
		f)
		  echo "nacteno f"
		  ;;
		n)
		  echo "nacteno n"
		  ;;
		\?)
		  echo "Invalid option: -$OPTARG" >&2
		  ;;
	  esac
	done
	shift `expr $OPTIND - 1`
