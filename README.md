# libinput-magic-mouse

## Prerequisites

As of recently, this guide is only written for Ubuntu. But it shouldn't be too hard to adjust for other distributions.

This guide used to be based upon libinput-gestures, but is now using [fusuma](https://github.com/iberianpig/fusuma)

Please install fusuma according to its installation guide. In short:

```bash
sudo gpasswd -a $USER input
sudo apt install ruby libinput-tools wmctrl
sudo gem install fusuma fusuma-plugin-wmctrl fusuma-plugin-keypress
```

## Configuration for fusuma

```bash
mkdir -p ~/.config/fusuma
vim ~/.config/fusuma/config.yml
```

Example configurations are available on the [fusuma](https://github.com/iberianpig/fusuma) repository. Mine is included inside this repo. To use it:

```bash
cp -v fusuma-config.yml ~/.config/fusuma/config.yml
```

## systemd service for fusuma

place `/etc/systemd/system/fusuma.service`:

```systemd
[Unit]
Description=Fusuma
StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=jeffrey
Group=jeffrey
Environment="DISPLAY=:0"
ExecStart=/usr/local/bin/fusuma
Type=simple
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

*Obviously, adjust the `User` and `Group` settings*

And enable the service:

```bash
systemctl daemon-reload
systemctl enable --now fusuma.service
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
