#!/bin/bash
# Vytvori animaci grafu na zaklade zadaneho datoveho souboru

VERBOSE=0

USAGE=$(cat <<USAGE
Usage:  $0 [-v] [-p prefix] file...
        $0 -h

        file       input data file
        -p prefix  output animation prefix
        -v         verbose
        -h         this help
USAGE
)

#------------------------------------------------

function err { echo "$0[error]: $@" >&2; exit 2; }
function cleanup {
	rm -r "$TMP"
	verbose "Removed '$TMP' temporary directory"
	exit
}
function verbose { ((VERBOSE)) && echo "$0[info]: $@" >&2; }
function vverbose { ((VERBOSE>1)) && echo "$0[info2]: $@" >&2; }

# Zpracovani prepinacu
while getopts vhp: opt
do
	case "$opt" in
		v) ((VERBOSE++));;
		p) PREFIX="$OPTARG";;
		h) echo "$USAGE"; exit 0;;
		\?) echo "$USAGE" >&2; exit 2;;
	esac
done
shift $((OPTIND-1))

# Test na pocet argumentu
if [ $# -eq 0 ]
then
	echo "$USAGE" >&2
	err "Argument missing"
fi

# Vytvoreni docasneho adresare
TMP=$(mktemp -d) || err "Cannot create temporary directory"
verbose "Created '$TMP' temporary directory"

# Uklidit po skonceni skriptu
trap cleanup EXIT

for data
do
	verbose "Processing '$data' file"

	# Vystupni soubor (animace)
	anim="$PREFIX$data.mp4"

	# Testy vstupniho souboru
	[ -f "$data" ] || err "argument '$data' is not a file"
	[ -r "$data" ] || err "file '$data' is not readable"
	[ -s "$data" ] || err "file '$data' is empty"

	# Pocet radku vstupniho souboru
	lines=$(wc -l <"$data")

	# Pocet potrebnych cifer v nazvu policka
	digits=${#lines}

	# Rozsahy dat
	xrange="1:$lines"
	yrange=$(awk '
		NR==1  { min=$1; max=$1 }
		$1>max { max=$1 }
		$1<min { min=$1 }
		END 	 { print int(min)-1 ":" int(max)+1 }
	' "$data")

	first=1
	# Vytvorit sadu snimku (policek filmu)
	for ((frame=1;frame<=lines;frame++))
	do
		((p=100*frame/lines))

		((p%10==0 && first)) && { vverbose "$p % done"; first=0; }
		((p%10)) && first=1

		# gnuplot script
		GP=$(cat <<-GNUPLOT
			set terminal png
			set output "$TMP/$(printf "%0${digits}d.png" "$frame")"
			set xrange [$xrange]
			set yrange [$yrange]
			plot '-' with lines t""
			GNUPLOT
		)

		# Pripravit data pro 1 snimek
		DATA=$(head -n "$frame" "$data")

		# Zavolat gnuplot a vytvorit snimek
		printf "%s\n" "$GP" "$DATA" | gnuplot
	done

	# Spojit snimky do jednoho videa
	ffmpeg -y -i "$TMP/%0${digits}d.png" "$anim" 2>/dev/null || err "Error during ffmpeg execution"
	verbose "Animation in '$anim' file"
done
