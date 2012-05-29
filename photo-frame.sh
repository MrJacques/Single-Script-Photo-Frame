#!/bin/bash

# Copyright 2012 Jacques Parker
#
# This file is part of the Single-Script-Photo-Frame.
#
# Single-Script-Photo-Frame is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version.
#
# The Single-Script-Photo-Frame script is distributed in the hope that it
# will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# the Single-Script-Photo-Frame.  If not, see <http://www.gnu.org/licenses/>.

# Edit the settings below as needed

# Path to pictures.  This should end with a / and is the directory containing
# the pictures to be displayed.  Any pictures in this or any subdirectories
# will be displayed.
PIC_PATH="/home/jp/Dropbox/Frame/"

# File to store a small hash made from the PIC_PATH directory.  The running
# script must be able to create, write to and overwrite this file.
LIST_HASH="/home/jp/frame-contents.txt"

# Delay in seconds between pictures
DELAY="30"

# Starting hour.  The script will turn off the display between midnight and
# the time specified.  The time should be in the format HH:MM
START_TIME="08:30"

# Stopping hour.  The script will turn off the display between the time 
# specified and midnight.  The time should be in the format HH:MM
STOP_TIME="22:30"

# End of settings

export DISPLAY=:0

# Stop the script from running if a particular file is found
# Uncomment to enable this functionality
#if [ -f /home/jp/Dropbox/Frame/stop ]
#then 
#  exit
#fi

# Figure out if it should be running or not
# TURN_OFF will be set to 1 if the display should be turned off
TURN_OFF=0

# Get seconds since the epoch for the start time today, the stop time
# today and the current time.
EPOCH_TIME_START=`date --date="$START_TIME" +%s`
EPOCH_TIME_STOP=`date --date="$STOP_TIME" +%s`
EPOCH_TIME_CURRENT=`date +%s`

if [ $EPOCH_TIME_START -gt $EPOCH_TIME_CURRENT ]
then 
  TURN_OFF=1
fi

if [ $EPOCH_TIME_STOP -lt $EPOCH_TIME_CURRENT ]
then
  TURN_OFF=1
fi

# If the PIC_PATH directory is not found the turn off
if [ ! -d $PIC_PATH ] 
then
  echo $PIC_PATH not found
  TURN_OFF=1
fi

# Exit if it should not be running
if [ $TURN_OFF == 1 ] 
then
  # Older devices may not turn off as expected.  Included are two methods
  # to force the lcd off.  Different methods may work better or not at all
  # with different devices.  

  # Sometimes xset -q was reporting the lcd on when it was in fact off.  
  # If your device turns off then back on, try uncommenting these two lines
  #xset dpms force on
  #xset s reset

  # Method #1 - Use energy star to turn off display
  xset dpms force off

  # Method #2 - Use the screensaver to blank the display
  #xset s blank
  #xset s on
  #xset s 1
  #xset s activate

  # stop the slideshow
  killall -q feh
  exit
fi

# Figure out if anything has changed since the last time
# the LIST_HASH was created

# RESTART_SHOW.  A value of 1 indicates that the slideshow should be restarted
RESTART_SHOW=1
if [ -f $LIST_HASH ] 
then
  # Take a full recursive ls and pipe it through md5sum for easier and safer
  # comparing
  CURRENT=`ls -lR $PIC_PATH | md5sum`

  # Retrieve the previous listing hash result
  PREVIOUS=`cat $LIST_HASH`

  if [ "$PREVIOUS" == "$CURRENT" ] 
  then
    RESTART_SHOW=0
  fi
fi

# TODO It is a little inefficient to do a second ls.  This could be rewritten
# to only do a ls if one wasn't done above.

# Do a second ls and store the hash
ls -lR $PIC_PATH | md5sum > $LIST_HASH

# If feh isn't running then use RESTART_SHOW to force it
if [ ! "$(pidof feh)" ]
then
  RESTART_SHOW=1
fi

if [ $RESTART_SHOW == 1 ]
then
  # Turn off energy star and disable/turn off screensaver. i.e. Turn screen on
  xset dpms force on
  xset s reset
  xset s off

  # Stop any current slideshow
  killall -q feh

  # Start feh with the listed options.
  feh --quiet \
    --recursive \
    --full-screen \
    --slideshow-delay $DELAY \
    --hide-pointer \
    --caption-path "./" \
    $PIC_PATH &
fi

