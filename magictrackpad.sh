#!/bin/bash

export DISPLAY=":0"

# Clean old libinputs
for pid in $(pgrep libinput); do 
	kill $pid; 
done 

# Start libinput-gestures again
su -c "DISPLAY=':0' libinput-gestures 2>/dev/null" - jeffrey &

