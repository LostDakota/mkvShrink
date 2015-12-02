#!/bin/bash

DURATION=`mediainfo --Inform="General;%Duration%" "$1"`
INSECONDS=$(($DURATION / 1000))
EXTRA=`printf "%.0f" $(echo "scale=2;$2*.05" | bc)`
FULL=$(($2 + $EXTRA))
SIZE=$(($FULL * 1000 * 8))
BITRATE=$(($SIZE / $INSECONDS - 128))
BASENAME=$(basename "$1")
FORMAT=`echo $BASENAME | cut -f2 -d"."`
ORIGINALSIZE=`du "$1" | awk '{print $1}'`
OSIZE=$(($ORIGINALSIZE / 1024))
ACCEPTABLE=$(($2 + 5))
BUFFER=$(($BITRATE / 2))
THEDIR=~/transcode #Change this to wherever you like.
PRESET="veryslow" #Your options are ultrafast, superfast, veryfast, faster, fast, medium, slow, slower and veryslow. Each is half as fast as the one before.

if [ $OSIZE -lt $ACCEPTABLE ] ;then
	echo "Original size of $1 is sufficient at $OSIZE"
	echo "Original size of $1 is sufficient at $OSIZE" >> ~/transcode/mkvShrink.log
else

	echo "Checking for working directory..."

	if [ ! -d $THEDIR ] ; then
		mkdir $THEDIR
	fi

	echo "Moving to working directory..."

	cd $THEDIR

	echo "The video bitrate will be: $BITRATE"

	sleep 2

	START=`date +%s`

	avconv -y -i "$1" -pass 1 -c:v libx264 -b:v $BITRATE\k -preset veryslow -threads auto -an -f null -

	avconv -i "$1" -pass 2 -c:v libx264 -b:v $BITRATE\k -c:a libmp3lame -b:a 128k -preset veryslow -threads auto -sn "$BASENAME"

	END=`date +%s`

	TOTAL=$(($END - $START))

	echo "Encoding of $BASENAME completed in `expr $TOTAL / 60` minutes"

	echo "Encoding of $BASENAME completed in `expr $TOTAL / 60` minutes at `date +%l:%m' '%a' '%D`" >> ~/transcode/mkvShrink.log

	echo "Would you like to replace the original? (Y or N)"

	read REPLACE

	if [ $REPLACE = Y ] ; then
		mv $BASENAME $1
	else
		echo "Output file is retained in `pwd`";
	fi

fi
