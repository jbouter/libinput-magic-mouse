# libinput-magic-mouse

## Prerequisites
This guide is written for Ubuntu and Arch, when using [libinput-gestures (github)](https://github.com/bulletmark/libinput-gestures) in combination with an Apple Magic Trackpad 2.

When using arch, installing `libinput-gestures-git` through AUR is recommended.

This works with both USB and Bluetooth. Improvements are welcome.

## udev rules
Write the udev rules to detect attaching and detaching of the trackpad:

`/etc/udev/rules.d/20-magic-trackpad.rules`:

```console
ACTION=="bind|unbind", ENV{SUBSYSTEM}=="hid", ENV{DRIVER}=="magicmouse", RUN+="/usr/bin/systemctl restart magictrackpad"
ACTION=="remove", ENV{SUBSYSTEM}=="input", ENV{NAME}="Apple Inc. Magic Trackpad 2", RUN+="/usr/bin/systemctl restart magictrackpad"
```

Reload the udev rules:
```bash
sudo udevadm control --reload-rules
```

## systemd service

place `/etc/systemd/system/magictrackpad.service`:

```bash
[Unit]
Description=Libinput support for MagicMouse

[Service]
User=jeffrey
Group=jeffrey
Environment="DISPLAY=:0"
ExecStartPre=-/usr/bin/killall libinput-debug-events
ExecStart=/usr/bin/libinput-gestures
Restart=always
Type=simple

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
