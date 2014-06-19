#/bin/bash

<<HELP
	1. copy the srt files to the videos' directory
	2. copy this script to the videos' directory
	3. run this script
HELP

ls -1 *.mov|while read line
do
	id=`echo "$line"|cut -d'_' -f1`
	name=`echo "$line"|cut -d'.' -f1`
	find . -name "$id.srt" | while read srtFile
	do
		mv $srtFile "./$name.srt"
	done
done
echo Enjoy!
