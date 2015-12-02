##INTRODUCTION
-------------------------------------------------------
This bash script will run a two pass re-encode on a video 
file with the intent to change the file size to something 
more storage friendly. 
Supported files include, but are not limited to .mkv, .avi,
and .mp4.

##SUPPORT
-------------------------------------------------------
This script will run on a Debian/Ubuntu system. A temp 
directory (~/transcode) will be utilized to store the
output files. You can change where this is located by
adjusting the $THEDIR variable at the top of the script.
To run the script, chmod it to +x and supply a video 
file as the first argument. You should use absolute path
values, as an option is to replace the original file.
You must supply a second argument after the file.
This is the target file size in megabytes. To change
the speed of the encoding, alter the $PRESET variable.
I have found that the slower you can tolerate, the better
the encoding. By default, this is set to 'veryslow', and
it is... very slow.

The linux utility 'screen' is also helpful, due to the 
long duration of encoding video.

```sh
screen -dmS SOME_TITLE
```
And then run:
```sh
screen -r SOME_TITLE
./mkvShrink.sh ~/Movies/"Title of the Movie.mkv" 700
```


##DEPENDENCIES
-------------------------------------------------------
You will need avconv and mediainfo, both available to you in
the Ubuntu repositories.

```sh
sudo apt-get install avconv mediainfo
```
Optional dependencies are twidge and screen.

