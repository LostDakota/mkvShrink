##INTRODUCTION
-------------------------------------------------------
This bash script will run a two pass re-encode on a video 
file with the intent to change the file size to something 
more storage friendly. 
Supported files include, but are not limited to .mkv, .avi, and .mp4.

##SUPPORT
-------------------------------------------------------
This script will run on a Debian/Ubuntu system. A temp 
directory will be utilized to store the output files. 
You can change where this is located by adjusting the $TEMPDIR 
variable at the top of the script. To run the script, chmod it 
to +x and supply a video file as the only argument. 
You should use absolute path values, as an option is to 
replace the original file, however you do not have to overwrite it.
The linux utility 'screen' is also helpful, due to the 
long duration of encoding video.
```sh
`screen -dmS SOME_TITLE


<h1>DEPENDENCIES</h1>
-------------------------------------------------------
You will need avconv and mediainfo, both available to you in the Ubuntu repositories.
```sh
`sudo apt-get install avconv mediainfo
Optional dependencies are twidge and screen.

