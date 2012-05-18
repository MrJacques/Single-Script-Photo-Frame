Copyright 2012 Jacques Parker

This file is part of the Single-Script-Photo-Frame.

Single-Script-Photo-Frame is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Single-Script-Photo-Frame is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with the Single-Script-Photo-Frame.  If not, see <http://www.gnu.org/licenses/>.
    
    
Single-Script-Photo-Frame
=========================

A single script that uses Dropbox, Google drive or any folder synchronization software to turn a machine into a photo frame.

This script was created because I wanted to turn an old laptop into a picture frame.  I had a few requirements and could not find an existing script to meet all of the requirements.

I had the following requirements:

1) Simple.  I wanted a single script that could be run from a cronjob and would just work.

2) Show the contents of a folder.  I wanted to show all the pictures contained in a single folder (and it's subfolders)

3) Pickup new pictures automatically.  The script should pickup new pictures in the pucture folder automatically.  The slideshow should not be inturrupted if there are not new pictures.

4) Turn off the photo frame at night.  It should be easy to specify when to turn off and on.  When it is off it should turn off the display.

The script meet all the requirements.  

Basically, create a folder to hold the pictures, put the script in the folder, and finally add a crontab entry to run every fifteen minutes (or however often you want it to check for new picutres.)  Then use dropbox or other software to add pictures to the folder.  If you need to edit the script, you can do it anywhere and let the synchronizing software move it to the picture frame.  

I didn't see see any existing photo frame scripts that would pick up new pictures without restarting the slideshow.  I use a simple trick to detect changes to the picture folder and restart the slideshow if changes are detected.  The script creates an md5 hash of an ls -lR of the picture folder.  It then stores tha hash and compares it against future hashes to detect any changes.

The script uses the date command and a bit of bash script magic  to figure out if the frame should be awake or asleep.  It does make the assumption that bedtime is before midnight.

