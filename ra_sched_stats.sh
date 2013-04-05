#!/bin/bash

# Copyright (C) Stefan Heykes 2013
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Generating statistics for the monthly RadioAstron block schedule files published by ASC
# Optimized for the format used since Feb 2013 - older files need to be reformatted
# Block schedules can be downloaded here: ftp://jet.asc.rssi.ru/outgoing/yyk/Radioastron/block_schedule/
# $1 = Block schedule file $2 = Output file, also needed as a temporary buffer!
# This script generates to output files - "$2" contains the output as BBCode, "$2.csv" as Comma-Separated-Values
# This script uses BSD date to convert date/time!
#
# If you fix any bugs in this script (or manage to use GNU date, which seems to be better for Linux-Users), please let me know ;-)

# Extract time, baselines and used bands from the file - analyse only those observations for which the baseline is given
grep -v '#' "$1" | grep '\(Band:\)\|\( *xED\)\|\(Start(UT)\)\|\(Stop(UT)\)' | grep -B 3 'Comment' | grep '\(Band:\)\|\( *xED\)\|\(Start(UT)\)\|\(Stop(UT)\)' > "$2"

# Variables to store statistical values
K_COUNT=`grep 'K' "$2" | wc -l`
K_COUNT=`expr $K_COUNT + 0`
K_TIME=0
K_MIN=50
K_MAX=0
K_AVRG=0

C_COUNT=`grep 'Band:' "$2" | grep 'C' | wc -l`
C_COUNT=`expr $C_COUNT + 0`
C_TIME=0
C_MIN=50
C_MAX=0
C_AVRG=0

L_COUNT=`grep 'L' "$2" | wc -l`
L_COUNT=`expr $L_COUNT + 0`
L_TIME=0
L_MIN=50
L_MAX=0
L_AVRG=0

P_COUNT=`grep 'P' "$2" | wc -l`
P_COUNT=`expr $P_COUNT + 0`
P_TIME=0
P_MIN=50
P_MAX=0
P_AVRG=0


SUM_TIME=0
SUM_COUNT=`cat "$2" | wc -l`
SUM_COUNT=`expr $SUM_COUNT / 4`
SUM_MIN=50
SUM_MAX=0
SUM_AVRG=0

# Analyzing single observations
I=0
while [ $I -lt $SUM_COUNT ];do
	I=`expr $I + 1`
	POS=`expr $I \* 4 - 3`
	TIME_START=`head -n "$POS" "$2" | tail -n 1 | sed -e '/S/s/Start(UT): //g'`
	# Echo start time as debugging information - errors can occur when the input file entry differs from the standard format
	# in case of errors simply adjust the input file before running this script again
	echo "$TIME_START"
	TIME_START=`date -j -f "%d.%m.%Y %H:%M:%S" "$TIME_START" "+%s"`
	POS=`expr $POS + 1`
	TIME_STOP=`head -n "$POS" "$2" | tail -n 1 | sed -e '/S/s/Stop(UT) : //g'`
	TIME_STOP=`date -j -f "%d.%m.%Y %H:%M:%S" "$TIME_STOP" "+%s"`
	TIME_OBSERVATION=`expr $TIME_STOP - $TIME_START`
	POS=`expr $POS + 1`
	#head -n "$POS" "$2" | tail -n 1
	BAND=`head -n "$POS" "$2" | tail -n 1 | sed -e '/B/s/Band: //g'`
	POS=`expr $POS + 1`
	#head -n "$POS" "$2" | tail -n 1
	BASELINE=`head -n "$POS" "$2" | tail -n 1 | sed -e '/C/s/Comments: //g' | sed 's/\([0-9]*\).*/\1/'`
	
	
	SUM_AVRG=`expr $SUM_AVRG + $BASELINE`
	SUM_TIME=`expr $SUM_TIME + $TIME_OBSERVATION`
	if [ $SUM_MIN -gt $BASELINE ]
		then
			SUM_MIN=$BASELINE
		fi
		if [ $SUM_MAX -lt $BASELINE ]
		then
			SUM_MAX=$BASELINE
	fi
	case "${BAND:0:1}" in
		K)
			K_AVRG=`expr $K_AVRG + $BASELINE`
			K_TIME=`expr $K_TIME + $TIME_OBSERVATION`
			if [ $K_MIN -gt $BASELINE ]
			then
				K_MIN=$BASELINE
			fi
			if [ $K_MAX -lt $BASELINE ]
			then
				K_MAX=$BASELINE
			fi
		;;
		C)
			C_AVRG=`expr $C_AVRG + $BASELINE`
			C_TIME=`expr $C_TIME + $TIME_OBSERVATION`
			if [ $C_MIN -gt $BASELINE ]
			then
				C_MIN=$BASELINE
			fi
			if [ $C_MAX -lt $BASELINE ]
			then
				C_MAX=$BASELINE
			fi
		;;
		L)
			L_AVRG=`expr $L_AVRG + $BASELINE`
			L_TIME=`expr $L_TIME + $TIME_OBSERVATION`
			if [ $L_MIN -gt $BASELINE ]
			then
				L_MIN=$BASELINE
			fi
			if [ $L_MAX -lt $BASELINE ]
			then
				L_MAX=$BASELINE
			fi
		;;
		P)
			P_AVRG=`expr $P_AVRG + $BASELINE`
			P_TIME=`expr $P_TIME + $TIME_OBSERVATION`
			if [ $P_MIN -gt $BASELINE ]
			then
				P_MIN=$BASELINE
			fi
			if [ $P_MAX -lt $BASELINE ]
			then
				P_MAX=$BASELINE
			fi
		;;
		*)
		;;
	esac
	if [ ${BAND:0:1} != ${BAND:1:1} ]
	then
		case "${BAND:1:1}" in
			K)
				K_AVRG=`expr $K_AVRG + $BASELINE`
				K_TIME=`expr $K_TIME + $TIME_OBSERVATION`
				if [ $K_MIN -gt $BASELINE ]
				then
					K_MIN=$BASELINE
				fi
				if [ $K_MAX -lt $BASELINE ]
				then
					K_MAX=$BASELINE
				fi
			;;
			C)
				C_AVRG=`expr $C_AVRG + $BASELINE`
				C_TIME=`expr $C_TIME + $TIME_OBSERVATION`
				if [ $C_MIN -gt $BASELINE ]
				then
					C_MIN=$BASELINE
				fi
				if [ $C_MAX -lt $BASELINE ]
				then
					C_MAX=$BASELINE
				fi
			;;
			L)
				L_AVRG=`expr $L_AVRG + $BASELINE`
				L_TIME=`expr $L_TIME + $TIME_OBSERVATION`
				if [ $L_MIN -gt $BASELINE ]
				then
					L_MIN=$BASELINE
				fi
				if [ $L_MAX -lt $BASELINE ]
				then
					L_MAX=$BASELINE
				fi
			;;
			P)
				P_AVRG=`expr $P_AVRG + $BASELINE`
				P_TIME=`expr $P_TIME + $TIME_OBSERVATION`
				if [ $P_MIN -gt $BASELINE ]
				then
					P_MIN=$BASELINE
				fi
				if [ $P_MAX -lt $BASELINE ]
				then
					P_MAX=$BASELINE
				fi
			;;
			*)
			;;
		esac
	fi
done

# Calculating average baselines

K_AVRG=`expr $K_AVRG / $K_COUNT`
if [ $? -ne 0 ]
then
	K_MIN="n/a"
	K_MAX="n/a"
	K_AVRG="n/a"
fi
C_AVRG=`expr $C_AVRG / $C_COUNT`
if [ $? -ne 0 ]
then
	C_MIN="n/a"
	C_MAX="n/a"
	C_AVRG="n/a"
fi
L_AVRG=`expr $L_AVRG / $L_COUNT`
if [ $? -ne 0 ]
then
	L_MIN="n/a"
	L_MAX="n/a"
	L_AVRG="n/a"
fi
P_AVRG=`expr $P_AVRG / $P_COUNT`
if [ $? -ne 0 ]
then
	P_MIN="n/a"
	P_MAX="n/a"
	P_AVRG="n/a"
fi
SUM_AVRG=`expr $SUM_AVRG / $SUM_COUNT`
if [ $? -ne 0 ]
then
	SUM_MIN="n/a"
	SUM_MAX="n/a"
	SUM_AVRG="n/a"
fi

# Calculate the total amount of observations
K_NUM=`grep -v '#' "$1" | grep 'Band:' | grep 'K' | wc -l`
C_NUM=`grep -v '#' "$1" | grep 'Band:' | grep 'C' | wc -l`
L_NUM=`grep -v '#' "$1" | grep 'Band:' | grep 'L' | wc -l`
P_NUM=`grep -v '#' "$1" | grep 'Band:' | grep 'P' | wc -l`
SUM_NUM=`grep -v '#' "$1" | grep 'Band:' | wc -l`

#Generate CSV
echo "Band;Total Number;Analysed Number;Min.Baseline;Max.Baseline;Avrg.Baseline;Time" > "$2.csv"
echo "K(1.35cm);$K_NUM;$K_COUNT;$K_MIN;$K_MAX;$K_AVRG;$K_TIME" >> "$2.csv"
echo "C(6.2cm);$C_NUM;$C_COUNT;$C_MIN;$C_MAX;$C_AVRG;$C_TIME" >> "$2.csv"
echo "L(18cm);$L_NUM;$L_COUNT;$L_MIN;$L_MAX;$L_AVRG;$L_TIME" >> "$2.csv"
echo "P(92cm);$P_NUM;$P_COUNT;$P_MIN;$P_MAX;$P_AVRG;$P_TIME" >> "$2.csv"
echo "Total;$SUM_NUM;$SUM_COUNT;$SUM_MIN;$SUM_MAX;$SUM_AVRG;$SUM_TIME" >> "$2.csv"

# Format the cumulated times to Days:Hours:Minutes

SUM_TIME=`date -j -f "%s" $SUM_TIME "+%d:%H:%m"`
if [ $K_TIME -ne 0 ]
then
	K_TIME=`date -j -f "%s" $K_TIME "+%d:%H:%m"`
fi
if [ $C_TIME -ne 0 ]
then
	C_TIME=`date -j -f "%s" $C_TIME "+%d:%H:%m"`
fi
if [ $L_TIME -ne 0 ]
then
	L_TIME=`date -j -f "%s" $L_TIME "+%d:%H:%m"`
fi
if [ $P_TIME -ne 0 ]
then
	P_TIME=`date -j -f "%s" $P_TIME "+%d:%H:%m"`
fi

# Output results as plain text
echo "Band      TotalNumber	Anal.Number	Min.BL	Max.BL	Avrg.BL		Time"
echo "K(1.3cm)  $K_NUM		$K_COUNT	$K_MIN	$K_MAX	$K_AVRG		$K_TIME"
echo "C(6.2cm)  $C_NUM		$C_COUNT	$C_MIN	$C_MAX	$C_AVRG		$C_TIME"
echo "L(18cm)   $L_NUM		$L_COUNT	$L_MIN	$L_MAX	$L_AVRG		$L_TIME"
echo "P(92cm)   $P_NUM		$P_COUNT	$P_MIN	$P_MAX	$P_AVRG		$P_TIME"
echo "Total	$SUM_NUM		$SUM_COUNT	$SUM_MIN	$SUM_MAX	$SUM_AVRG		$SUM_TIME"

echo ""
echo ""

# Generate BBCode

echo "[table]" > "$2"
echo "[tr][td]Band[/td][td]Total Number of observations[/td][td]Analysed Observations[/td][td]Min. Baseline[/td][td]Max. Baseline[/td][td]Average Baseline[/td][td]Observation Time[/td][/tr]" >> "$2"
echo "[tr][td]K(1.35cm)[/td][td]$K_NUM[/td][td]$K_COUNT[/td][td]$K_MIN[/td][td]$K_MAX[/td][td]$K_AVRG[/td][td]$K_TIME[/td][/tr]" >> "$2"
echo "[tr][td]C(6.2cm)[/td][td]$C_NUM[/td][td]$C_COUNT[/td][td]$C_MIN[/td][td]$C_MAX[/td][td]$C_AVRG[/td][td]$C_TIME[/td][/tr]" >> "$2"
echo "[tr][td]L(18cm)[/td][td]$L_NUM[/td][td]$L_COUNT[/td][td]$L_MIN[/td][td]$L_MAX[/td][td]$L_AVRG[/td][td]$L_TIME[/td][/tr]" >> "$2"
echo "[tr][td]P(92cm)[/td][td]$P_NUM[/td][td]$P_COUNT[/td][td]$P_MIN[/td][td]$P_MAX[/td][td]$P_AVRG[/td][td]$P_TIME[/td][/tr]" >> "$2"
echo "[tr][td]Total[/td][td]$SUM_NUM[/td][td]$SUM_COUNT[/td][td]$SUM_MIN[/td][td]$SUM_MAX[/td][td]$SUM_AVRG[/td][td]$SUM_TIME[/td][/tr]" >> "$2"
echo "[/table]" >> "$2"
# Output BBCode for direct copy&paste
cat "$2"