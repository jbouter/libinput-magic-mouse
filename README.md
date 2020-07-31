# libinput-magic-mouse

## Prerequisites
This guide is written for Ubuntu and Arch, when using [libinput-gestures (github)](https://github.com/bulletmark/libinput-gestures) in combination with an Apple Magic Trackpad 2.

When using arch, installing `libinput-gestures-git` through AUR is recommended.

This works with both USB and Bluetooth. Improvements are welcome.

## udev rules
Write the udev rules to detect attaching and detaching of the trackpad:

`/etc/udev/rules.d/20-magic-trackpad.rules`:

```console
ACTION=="bind|unbind", ENV{SUBSYSTEM}=="hid", ENV{DRIVER}=="magicmouse", RUN+="/bin/systemctl restart libinput-gestures"
ACTION=="remove", ENV{SUBSYSTEM}=="input", ENV{NAME}="Apple Inc. Magic Trackpad 2", RUN+="/bin/systemctl restart libinput-gestures"
```

Note: The systemctl path varies per distribution. For Arch, this should be `/usr/bin/systemctl`, whereas for Debian based distros this is `/bin/systemctl`

Reload the udev rules:
```bash
sudo udevadm control --reload-rules
```

## systemd service

place `/etc/systemd/system/libinput-gestures.service`:

```systemd
[Unit]
Description=Libinput Gestures

[Service]
User=jeffrey
Group=jeffrey
Environment="DISPLAY=:0"
ExecStart=/usr/bin/libinput-gestures-setup start
ExecStop=/usr/bin/libinput-gestures-setup stop
ExecReload=/usr/bin/libinput-gestures-setup restart
Type=forking

[Install]
WantedBy=multi-user.target
```

And enable the service:

```bash
systemctl daemon-reload
systemctl enable --now magictrackpad.service
```

## Libinput Quirks

In order to get the touchpad to work properly, create the following file:

`/etc/libinput/local-overrides.quirks`:

```code
[Touchpad touch override]
MatchUdevType=touchpad
MatchName=*Magic Trackpad 2
AttrPressureRange=2:0
AttrTouchSizeRange=20:10
```

## Xorg configuration

Last time I tested the touchpad with KDE Plasma on 20.04 (Neon), I needed to configure the Trackpad through xorg settings

```bash
mkdir -p /etc/X11/xorg.conf.d
```

`/etc/X11/xorg.conf.d/10-libinput.conf`:

```code
Section "InputClass"
  Identifier "libinput touchpad catchall"
  MatchIsTouchpad "on"
  MatchDevicePath "/dev/input/event*"
  Option "Tapping" "True"
  Option "TappingDrug" "True"
  Option "DisableWhileTyping" "True"
  Option "AccelProfile" "adaptive"
  Option "AccelSpeed" "0.3"
  Option "AccelerationNumerator" "2"
  Option "AccelerationDenominator" "1"
  Option "AccelerationThreshold" "4"
  Option "AdaptiveDeceleration" "2"
  Option "NaturalScrolling" "1"
  Driver "libinput"
EndSection
```
