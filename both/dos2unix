#!/bin/sh 

printhelp () { 
 echo "dos2unix" 
 echo "dos2unix -h" 
 echo "dos2unix datei" 
 echo "dos2unix quelldatei zieldatei" 
 echo "dos2unix < quelldatei > zieldatei" 
} 

if [ $# -gt 2 -o "$1" = '-h' ] #wenn "-h" oder mehr als 2 parameter
then 
	printhelp 
elif [ $# -eq 0 ] #wenn genau 0 parameter
then 
	 while read line 
	do 
   		echo "`echo "$line" | tr -d '\r'`" 
 	done 
else 
 	if [ $# -eq 1 ]  #wenn genau 1 parameter
	then 
   		buffer=`cat $1 | tr -d '\r'` 
   		`echo "$buffer" | cat > $1` 
 	else #letzte option, es könne also nur 2 Paramater sein
   		`cat $1 | tr -d '\r' > $2` ; 
	fi
fi