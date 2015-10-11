#!/bin/bash

MOVIE=$1
DURATION=`mediainfo --Inform="General;%Duration%" "$1"`
SECONDS=`expr $DURATION / 1000`
MINUTES=`expr $DURATION / 60000`
BASENAME=$(basename "$MOVIE")
NEWLINE=`printf '\n'`
FORMAT=`echo $BASENAME | cut -f2 -d"."`
TEMPDIR=~/temp

clear

if [ $FORMAT == mkv ] ; then
	FORMAT=matroska
elif [ $FORMAT == avi ] ; then
	FORMAT=avi
elif [ $FORMAT == mp4 ] ; then
	FORMAT=mp4
else
	echo "I'm sorry. That filetype is not supported"
fi

echo -e "\e[94mWhat type of video is this? (film or animation)\e[0m"
read TYPE

echo -e "\e[94mThe video is $SECONDS seconds long. ($MINUTES min.)"
echo -e "What would you like the output size to be (in MB)?\e[0m"
$NEWLINE
read SIZE

SIZE=$(($SIZE * 1000 * 8))
OVERHEAD=`echo "$SIZE * .02" | bc | cut -f1 -d'.'`
SIZE=$(($SIZE + $OVERHEAD))
BITRATE=$(($SIZE / $SECONDS - 128))

$NEWLINE
echo -e "\e[94mThe bitrate will be $BITRATE"
echo "We will save the converted file to $TEMPDIR/$BASENAME"
echo "------------------------------------------------"

if [ ! -d ~/temp ] ; then
	mkdir $TEMPDIR
	echo "Creating the temp directory at $TEMPDIR"
fi

cd ~/temp

$NEWLINE
echo -e "\e[31mContinue? Y or N\e[0m"

read CONTINUE

if [ $CONTINUE == Y ] ; then
	$NEWLINE
	echo "Here we go..."
	sleep 1
	START1=`date +%s`
	$NEWLINE
	avconv -y -i "$MOVIE" -pass 1 -c:v libx264 -b:v $BITRATE\k -c:a libmp3lame -b:a 128k -tune $TYPE -preset slow -threads 1 -f $FORMAT -sn /dev/null & plexTest.sh
	PASS1=$((`date +%s` - $START1))
	START2=`date +%s`
	avconv -i "$MOVIE" -pass 2 -c:v libx264 -b:v $BITRATE\k -c:a libmp3lame -b:a 128k -tune $TYPE -preset slow -threads 1 -sn "$BASENAME" & plexTest.sh
	PASS2=$((`date +%s` - $START2))
	BSIZE=`stat -c %s "$BASENAME"`
	GSIZE=`echo "scale=1;$BSIZE / 1000000 / 1024" | bc -l`
	echo -e "\e[94mPass 1 completed in $(($PASS1 / 60)) minutes."
	echo -e "\e[94mPass 2 completed in $(($PASS2 / 60)) minutes."
	echo -e "\e[32mThe resulting file is $GSIZE G.\e[0m"
	echo -e "\e[31mDo you want to replace the old with the new? Y or N\e[0m"
	/var/www/markVI/scripts/parse.sh "$BASENAME is ready to be processed. `date +%l:%M%P`"

	read REPLACE
	if [ $REPLACE == Y ] ; then
		echo -e "\e[32mMoving $BASENAME to its final resting place...\e[0m"
		mv -v "$BASENAME" "$1"
		echo -e "\e[32mRemoving leftover avconv files...\e[0m"
		rm -v av*
		echo "Conversion and replacement complete."
	else
		echo "Files are retained here."
	fi
else
	$NEWLINE
	echo -e "\e[31m Script aborted."
fi
