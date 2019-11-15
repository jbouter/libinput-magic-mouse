# libinput-magic-mouse

## Prerequisites
This guide is written for Ubuntu, when using [libinput-gestures (github)](https://github.com/bulletmark/libinput-gestures) in combination with an Apple Magic Trackpad 2.

This works with both USB and Bluetooth. Improvements are welcome.

## udev rules
Write the udev rules to detect attaching and detaching of the trackpad:

`/etc/udev/rules.d/20-magic-trackpad.rules`:

```console
ACTION=="bind|unbind", ENV{HID_NAME}=="Magic Trackpad 2", RUN+="/usr/local/bin/magictrackpad.sh"
ACTION=="bind|unbind", ENV{SUBSYSTEM}=="hid", ENV{HID_NAME}=="Apple Inc. Magic Trackpad 2", RUN+="/usr/local/bin/magictrackpad.sh"
```

Reload the udev rules:
```bash
sudo udevadm control --reload-rules
```

## The script itself

`/usr/local/bin/magictrackpad.sh`:

```bash
#!/bin/bash

export DISPLAY=":0"

# Clean old libinputs
for pid in $(pgrep libinput); do 
	kill $pid; 
done 

# Start libinput-gestures again
su -c "DISPLAY=':0' libinput-gestures 2>/dev/null" - USER &
```

Be sure to replace `USER` with your own username.

Mark the script as executable and own by root:
```bash
sudo chown root: /usr/local/bin/magictrackpad.sh
sudo chmod 755 /usr/local/bin/magictrackpad.sh
```

# Libinput Quirks

In order to get the touchpad to work properly, create the following file:

`/etc/libinput/local-overrides.quirks`:

```code
[Touchpad touch override]
MatchUdevType=touchpad
MatchName=*Magic Trackpad 2
AttrPressureRange=2:0
AttrTouchSizeRange=20:10
```
