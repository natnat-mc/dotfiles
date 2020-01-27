#!/bin/sh

# setup touchpad parameters
touchpadid=`xinput list | grep Synaptics | cut -d= -f2 | cut -f1`
tapid=`xinput list-props $touchpadid | grep "Tapping Enabled" | grep -v "Default" | cut -d'(' -f2 | cut -d')' -f1`
scrollid=`xinput list-props $touchpadid | grep "Natural Scrolling Enabled" | grep -v "Default" | cut -d'(' -f2 | cut -d')' -f1`
speedid=`xinput list-props $touchpadid | grep "Coordinate Transformation Matrix" | grep -v "Default" | cut -d'(' -f2 | cut -d')' -f1`
disablewhiletypingid=`xinput list-props $touchpadid | grep "Disable While Typing Enabled" | grep -v "Default" | cut -d'(' -f2 | cut -d')' -f1`
xinput set-prop $touchpadid $tapid 1
xinput set-prop $touchpadid $scrollid 0
xinput set-prop $touchpadid $speedid 5 0 0 0 5 0 0 0 2
xinput set-prop $touchpadid $disablewhiletypingid 0

# use picom compositor
picom --vsync --backend glx &

# setup kdeconnect
kdeconnect-indicator >/dev/null 2>&1 &
~/git/statusbar/start.sh &
